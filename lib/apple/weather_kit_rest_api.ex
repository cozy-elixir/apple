defmodule Apple.WeatherKitRestAPI do
  @moduledoc """
  Utilities for [WeatherKit REST API](https://developer.apple.com/documentation/weatherkitrestapi).
  """

  alias JOSE.{JWK, JWS, JWT}

  @typedoc """
  The team ID, like `"6MPDV0UYYX"`.
  """
  @type team_id :: String.t()

  @typedoc """
  The private key ID, like `"2Y9R5HMY68"`.
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
  The registered service ID, like `"com.example.weatherkit-client"`.
  """
  @type service_id :: String.t()

  @doc """
  Builds a token to authorize HTTP requests.

  To get the value of arguments, such as `team_id`, `key_id` and so on,
  please read [Request authentication for WeatherKit REST API](https://developer.apple.com/documentation/weatherkitrestapi/request_authentication_for_weatherkit_rest_api).

  After building it, use it in the `Authorization` header like this:

  ```text
  Authorization: Bearer <JWT>
  ```
  """
  @spec build_auth_token!(team_id(), key_id(), private_key(), service_id()) :: String.t()
  def build_auth_token!(team_id, key_id, private_key, service_id)
      when is_binary(team_id) and
             is_binary(key_id) and
             is_binary(private_key) and
             is_binary(service_id) do
    issued_at = unix_time_in_seconds()

    # Expire the token after 90 seconds.
    expired_at = issued_at + 90

    header = %{
      "alg" => "ES256",
      "kid" => key_id,
      "type" => team_id <> "." <> service_id
    }

    payload = %{
      "iss" => team_id,
      "iat" => issued_at,
      "exp" => expired_at,
      "sub" => service_id
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
