defmodule Apple.AppStoreServerAPI do
  @moduledoc """
  Utilities for [App Store Server API](https://developer.apple.com/documentation/appstoreserverapi).
  """

  alias JOSE.{JWK, JWS, JWT}

  @typedoc """
  The issuer ID, like `"57246542-96fe-1a63-e053-0824d011072a"`
  """
  @type issuer_id :: String.t()

  @typedoc """
  The private key ID, like `"2X9R4HXF34"`.
  """
  @type key_id :: String.t()

  @typedoc """
  The private key associated with the `key_id`.

  It's in PEM format, like:

  ```text
  -----BEGIN PRIVATE KEY-----
  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  ...
  -----END PRIVATE KEY-----
  ```
  """
  @type private_key :: String.t()

  @typedoc """
  The app's bundle ID, like `"com.example.demo"`.
  """
  @type bundle_id :: String.t()

  @doc """
  Builds a token to authorize HTTP requests.

  To get the value of arguments, such as `issuer_id`, `key_id` and so on,
  please read [Generating JSON Web Tokens for API requests](https://developer.apple.com/documentation/appstoreserverapi/generating_json_web_tokens_for_api_requests).

  After building it, use it in the `Authorization` header like this:

  ```text
  Authorization: Bearer <JWT>
  ```  
  """
  @spec build_auth_token!(issuer_id(), key_id(), private_key(), bundle_id()) :: String.t()
  def build_auth_token!(issuer_id, key_id, private_key, bundle_id)
      when is_binary(issuer_id) and
             is_binary(key_id) and
             is_binary(private_key) and
             is_binary(bundle_id) do
    issued_at = unix_time_in_seconds()

    # Expire the token after 90 seconds.
    expired_at = issued_at + 90

    header = %{
      "alg" => "ES256",
      "kid" => key_id,
      "type" => "JWT"
    }

    payload = %{
      "iss" => issuer_id,
      "iat" => issued_at,
      "exp" => expired_at,
      "aud" => "appstoreconnect-v1",
      "bid" => bundle_id
    }

    jwk = JWK.from_pem(private_key)
    jws = JWS.from_map(header)
    jwt = JWT.from_map(payload)

    {_, token} = JWT.sign(jwk, jws, jwt) |> JWS.compact()
    token
  end

  defp unix_time_in_seconds() do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
