defmodule Apple.AppleMusicAPI do
  @moduledoc """
  Utilities for [Apple Music API](https://developer.apple.com/documentation/applemusicapi).

  The Apple Music API allows you to access the Apple Music catalog, user library,
  and perform searches. It requires both a developer token (JWT) and optionally
  a user token for personalized requests.
  """

  alias JOSE.{JWK, JWS, JWT}
  alias Apple.Types.AppleMusic

  @doc """
  Builds a developer token to authorize Apple Music API requests.

  The developer token is a JWT that identifies your app to Apple Music servers.
  It expires after 6 months (maximum allowed by Apple).

  ## Usage in Requests

  Include the token in the `Authorization` header:

  ```text
  Authorization: Bearer <JWT>
  ```

  For user-specific requests, also include the Music User Token:

  ```text
  Music-User-Token: <user-token>
  Authorization: Bearer <developer-JWT>
  ```

  ## More resources

    * [Apple Music API documentation](https://developer.apple.com/documentation/applemusicapi)
    * [Getting Keys and Creating Tokens](https://developer.apple.com/documentation/applemusicapi/getting_keys_and_creating_tokens)

  """
  @spec build_auth_token!(
          AppleMusic.key_id(),
          AppleMusic.private_key(),
          keyword()
        ) ::
          String.t()
  def build_auth_token!(key_id, private_key, opts \\ [])
      when is_binary(key_id) and
             is_binary(private_key) do
    issued_at = unix_time_in_seconds()

    # Apple Music tokens can be valid for up to 6 months
    # Default to 1 month for rotation safety
    expiration_days = Keyword.get(opts, :expiration_days, 30)
    expired_at = issued_at + expiration_days * 86400

    header = %{
      "alg" => "ES256",
      "kid" => key_id,
      "typ" => "JWT"
    }

    payload = %{
      "iat" => issued_at,
      "exp" => expired_at
    }

    jwk = JWK.from_pem(private_key)
    jws = JWS.from_map(header)
    jwt = JWT.from_map(payload)

    {_, token} = JWT.sign(jwk, jws, jwt) |> JWS.compact()
    token
  end

  @doc """
  Returns the Apple Music API base URL for the specified storefront.

  ## Examples

      iex> Apple.AppleMusicAPI.base_url("US")
      "https://api.music.apple.com/v1/catalog/US"

  """
  @spec base_url(AppleMusic.storefront()) :: String.t()
  def base_url(storefront) when is_binary(storefront) do
    "https://api.music.apple.com/v1/catalog/#{storefront}"
  end

  @doc """
  Returns the Apple Music API base URL for user library access.
  """
  @spec library_url() :: String.t()
  def library_url(), do: "https://api.music.apple.com/v1/me"

  defp unix_time_in_seconds() do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
