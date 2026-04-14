defmodule Apple.MapKitJSAPI do
  @moduledoc """
  Utilities for [MapKit JS](https://developer.apple.com/documentation/mapkitjs).

  MapKit JS allows you to embed Apple Maps in your web applications.
  This module provides JWT token generation for authenticating MapKit JS requests.
  """

  alias JOSE.{JWK, JWS, JWT}
  alias Apple.Types.Developer

  @doc """
  Builds a token to authorize MapKit JS requests.

  The token should be generated on your server and passed to the client.
  For web applications, use the `origin` parameter to restrict token usage
  to specific domains.

  ## Options

    * `:origin` - (optional) The domain origin for web token authorization,
      like `"https://example.com"`. If not provided, the token works for any origin.

  After building it, use it when initializing MapKit JS on your web page:

  ```javascript
  mapkit.init({
    authorizationCallback: function(done) {
      done('<JWT>');
    }
  });
  ```

  ## More resources

    * [Creating and Using Tokens with MapKit JS](https://developer.apple.com/documentation/mapkitjs/creating_and_using_tokens_with_mapkit_js)
    * [MapKit JS documentation](https://developer.apple.com/documentation/mapkitjs)

  """
  @spec build_auth_token!(
          Developer.team_id(),
          Developer.key_id(),
          Developer.private_key(),
          keyword()
        ) ::
          String.t()
  def build_auth_token!(team_id, key_id, private_key, opts \\ [])
      when is_binary(team_id) and
             is_binary(key_id) and
             is_binary(private_key) do
    issued_at = unix_time_in_seconds()

    # MapKit JS tokens expire after 1 hour (3600 seconds)
    expired_at = issued_at + 3600

    header = %{
      "alg" => "ES256",
      "kid" => key_id,
      "typ" => "JWT"
    }

    payload =
      %{
        "iss" => team_id,
        "iat" => issued_at,
        "exp" => expired_at
      }
      |> maybe_add_origin(opts[:origin])

    jwk = JWK.from_pem(private_key)
    jws = JWS.from_map(header)
    jwt = JWT.from_map(payload)

    {_, token} = JWT.sign(jwk, jws, jwt) |> JWS.compact()
    token
  end

  defp maybe_add_origin(payload, nil), do: payload

  defp maybe_add_origin(payload, origin) when is_binary(origin),
    do: Map.put(payload, "origin", origin)

  defp unix_time_in_seconds() do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
