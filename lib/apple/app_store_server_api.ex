defmodule Apple.AppStoreServerAPI do
  @moduledoc """
  Utilities for [App Store Server API](https://developer.apple.com/documentation/appstoreserverapi).
  """

  alias JOSE.{JWK, JWS, JWT}
  alias Apple.Types.AppStoreConnect

  @doc """
  Builds a token to authorize HTTP requests.

  > #### Note {: .info}
  > Using a private key of the "In-App Purchase" type is sufficient.

  After building it, use it in the `Authorization` header like this:

  ```text
  Authorization: Bearer <JWT>
  ```

  ## More resources

    * [Generating JSON Web Tokens for API requests](https://developer.apple.com/documentation/appstoreserverapi/generating_json_web_tokens_for_api_requests)

  """
  @spec build_auth_token!(
          AppStoreConnect.issuer_id(),
          AppStoreConnect.key_id(),
          AppStoreConnect.private_key(),
          AppStoreConnect.bundle_id()
        ) ::
          String.t()
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
