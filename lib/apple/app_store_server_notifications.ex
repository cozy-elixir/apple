defmodule Apple.AppStoreServerNotifications do
  @moduledoc """
  Utilities for [App Store Server Notifications](https://developer.apple.com/documentation/appstoreservernotifications).
  """

  alias JOSE.{JWS, JWK}

  @typedoc """
  The root certificate that Apple offers on [Apple PKI](https://www.apple.com/certificateauthority/).

  It's fine to use _Apple Root CA - G3 Root_.
  """
  @type root_cert :: binary()

  @typedoc """
  A cryptographically signed payload, in JSON Web Signature (JWS) format.
  """
  @type signed_payload :: String.t()

  @typedoc """
  The verified content extracted from signed payload.
  """
  @type payload :: map()

  @doc """
  Verifies a signed payload.

  ## References

    * https://github.com/potatosalad/erlang-jose/issues/63#issuecomment-1038751471
    * https://andrealeopardi.com/posts/verifying-apple-jwts/

  """
  @spec verify_signed_payload(root_cert(), signed_payload()) ::
          {:ok, payload()}
          | {:error, :invalid_format | :invalid_cert_chain | :invalid_signature}
  def verify_signed_payload(root_cert, signed_payload) do
    with {:ok, cert_chain} <- extract_cert_chain(signed_payload),
         {:ok, public_key} <- verify_cert_chain(root_cert, cert_chain),
         {:ok, payload} <- verify_signature(public_key, signed_payload) do
      {:ok, json_decode(payload)}
    end
  end

  defp extract_cert_chain(signed_payload) do
    try do
      # Decode the header of signed payload, and extract cert chain from the x5c field.
      %{"alg" => "ES256", "x5c" => base64_cert_chain} =
        signed_payload
        |> JWS.peek_protected()
        |> json_decode()

      # Decode cert chain and reverse it to the format expected by the verify function
      cert_chain =
        base64_cert_chain
        |> Enum.map(&Base.decode64!/1)
        |> Enum.reverse()

      {:ok, cert_chain}
    catch
      :error, :unsupported_json_module = reason ->
        {:error, reason}

      _, _ ->
        {:error, :invalid_format}
    end
  end

  defp verify_cert_chain(_root_cert, []) do
    {:error, :invalid_cert_chain}
  end

  defp verify_cert_chain(root_cert, cert_chain) do
    case :public_key.pkix_path_validation(root_cert, cert_chain, []) do
      {:ok, {{_key_oid_name, public_key_type, public_key_params}, _policy_tree}} ->
        public_key = {public_key_type, public_key_params}
        {:ok, public_key}

      _ ->
        {:error, :invalid_cert_chain}
    end
  end

  defp verify_signature(public_key, signed_payload) do
    # Convert the public key into a JWK
    jwk = JWK.from_key(public_key)

    case JWS.verify(jwk, signed_payload) do
      {true, payload, _protected_details} -> {:ok, payload}
      _ -> {:error, :invalid_signature}
    end
  end

  defp json_decode(binary) when is_binary(binary) do
    JOSE.json_module().decode(binary)
  end
end
