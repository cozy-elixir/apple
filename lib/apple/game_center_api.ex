defmodule Apple.GameCenterAPI do
  @moduledoc """
  Utilities for [Game Center API](https://developer.apple.com/documentation/gamekit).

  The Game Center API allows server-side access to leaderboards, achievements,
  and player data for games using Game Center.
  """

  alias JOSE.{JWK, JWS, JWT}
  alias Apple.Types.GameCenter

  @doc """
  Builds a token to authorize Game Center API requests.

  After building it, use it in the `Authorization` header like this:

  ```text
  Authorization: Bearer <JWT>
  ```

  ## More resources

    * [Game Center API documentation](https://developer.apple.com/documentation/gamekit)
    * [Game Center Web API](https://developer.apple.com/documentation/gamecenter/game_center_web_api)

  """
  @spec build_auth_token!(
          GameCenter.team_id(),
          GameCenter.key_id(),
          GameCenter.private_key(),
          GameCenter.bundle_id()
        ) ::
          String.t()
  def build_auth_token!(team_id, key_id, private_key, bundle_id)
      when is_binary(team_id) and
             is_binary(key_id) and
             is_binary(private_key) and
             is_binary(bundle_id) do
    issued_at = unix_time_in_seconds()

    # Game Center tokens expire after 1 hour
    expired_at = issued_at + 3600

    header = %{
      "alg" => "ES256",
      "kid" => key_id,
      "typ" => "JWT"
    }

    payload = %{
      "iss" => team_id,
      "iat" => issued_at,
      "exp" => expired_at,
      "bid" => bundle_id
    }

    jwk = JWK.from_pem(private_key)
    jws = JWS.from_map(header)
    jwt = JWT.from_map(payload)

    {_, token} = JWT.sign(jwk, jws, jwt) |> JWS.compact()
    token
  end

  @doc """
  Returns the Game Center API base URL.
  """
  @spec base_url() :: String.t()
  def base_url(), do: "https://api.gamecenter.apple.com"

  defp unix_time_in_seconds() do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
