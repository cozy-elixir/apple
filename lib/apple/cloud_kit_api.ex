defmodule Apple.CloudKitAPI do
  @moduledoc """
  Utilities for [CloudKit API](https://developer.apple.com/documentation/cloudkit/).

  CloudKit Web Services allows server-to-server access to CloudKit databases
  for managing records, assets, and queries outside of the Apple ecosystem.
  """

  alias JOSE.{JWK, JWS, JWT}
  alias Apple.Types.CloudKit

  @doc """
  Builds a token to authorize CloudKit Web Services requests.

  CloudKit uses a custom JWT format with a specific header structure.

  After building it, use it in the `Authorization` header like this:

  ```text
  Authorization: Bearer <JWT>
  ```

  ## More resources

    * [CloudKit Web Services documentation](https://developer.apple.com/documentation/cloudkit/web_services/)
    * [Authenticating Web Service Requests](https://developer.apple.com/documentation/cloudkit/authenticating_web_service_requests)

  """
  @spec build_auth_token!(
          CloudKit.key_id(),
          CloudKit.private_key()
        ) ::
          String.t()
  def build_auth_token!(key_id, private_key)
      when is_binary(key_id) and
             is_binary(private_key) do
    issued_at = unix_time_in_seconds()

    # CloudKit tokens expire after 1 hour
    expired_at = issued_at + 3600

    # CloudKit uses a special header format
    header = %{
      "alg" => "ES256",
      "kid" => key_id
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
  Returns the CloudKit Web Services base URL for the specified environment.

  ## Examples

      iex> Apple.CloudKitAPI.base_url(:production, "iCloud.com.example.app")
      "https://api.apple-cloudkit.com/database/1/iCloud.com.example.app/production"

      iex> Apple.CloudKitAPI.base_url(:development, "iCloud.com.example.app")
      "https://api.apple-cloudkit.com/database/1/iCloud.com.example.app/development"

  """
  @spec base_url(CloudKit.environment(), CloudKit.container_id()) :: String.t()
  def base_url(environment, container_id) when is_atom(environment) and is_binary(container_id) do
    env_str = to_string(environment)
    "https://api.apple-cloudkit.com/database/1/#{container_id}/#{env_str}"
  end

  @doc """
  Returns the CloudKit Web Services URL for a specific database.

  ## Examples

      iex> Apple.CloudKitAPI.database_url(:production, "iCloud.com.example.app", "public")
      "https://api.apple-cloudkit.com/database/1/iCloud.com.example.app/production/public"

  """
  @spec database_url(CloudKit.environment(), CloudKit.container_id(), CloudKit.database()) ::
          String.t()
  def database_url(environment, container_id, database)
      when is_atom(environment) and is_binary(container_id) and is_binary(database) do
    env_str = to_string(environment)
    "https://api.apple-cloudkit.com/database/1/#{container_id}/#{env_str}/#{database}"
  end

  defp unix_time_in_seconds() do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
