defmodule Apple.MapsServerAPI do
  @moduledoc """
  Utilities for [Maps Server API](https://developer.apple.com/documentation/applemapsserverapi).

  > #### Warning {: .warning}
  >
  > This service is not available in China, which means:
  >
  >   * If you are an Apple Developer in China, your account will not be able to apply for or use this service.
  >   * If the request's source IP is located in China, the request will be denied.

  """

  alias JOSE.{JWK, JWS, JWT}
  alias Apple.Types.Developer

  @typedoc """
  Something like `"*.example.com"`.
  """
  @type origin :: String.t()

  @doc """
  Builds a token to authorize HTTP requests.
  """
  @spec build_auth_token!(
          Developer.team_id(),
          Developer.key_id(),
          Developer.private_key(),
          origin() | nil
        ) :: String.t()
  def build_auth_token!(team_id, key_id, private_key, origin \\ nil)
      when is_binary(team_id) and
             is_binary(key_id) and
             is_binary(private_key) and
             (is_binary(origin) or is_nil(origin)) do
    issued_at = unix_time_in_seconds()

    # Expire the token after 90 seconds.
    expired_at = issued_at + 90

    header = %{
      "alg" => "ES256",
      "kid" => key_id,
      "type" => "JWT"
    }

    payload = %{
      "iss" => team_id,
      "iat" => issued_at,
      "exp" => expired_at
    }

    payload =
      if origin,
        do: Map.put(payload, "origin", origin),
        else: origin

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
