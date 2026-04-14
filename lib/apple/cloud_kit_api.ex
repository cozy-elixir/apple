defmodule Apple.CloudKitAPI do
  @moduledoc """
  Utilities for [CloudKit API](https://developer.apple.com/documentation/cloudkit/).

  CloudKit Web Services allows server-to-server access to CloudKit databases
  for managing records, assets, and queries outside of the Apple ecosystem.
  """

  alias Apple.JWT
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
    issued_at = JWT.unix_time_in_seconds()

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

    JWT.sign_es256!(private_key, header, payload)
  end

  @doc """
  Builds CloudKit Web Services signed request headers.

  `request_path` should be the full CloudKit path, for example:

      /database/1/iCloud.com.example.app/production/public/records/query
  """
  @spec signed_headers!(
          CloudKit.key_id(),
          CloudKit.private_key(),
          String.t(),
          binary(),
          keyword()
        ) :: map()
  def signed_headers!(key_id, private_key, request_path, request_body \\ "", opts \\ [])
      when is_binary(key_id) and is_binary(private_key) and is_binary(request_path) and
             is_binary(request_body) do
    request_date = Keyword.get(opts, :request_date, request_date())
    payload = Enum.join([request_date, body_sha256(request_body), request_path], ":")

    %{
      "x-apple-cloudkit-request-keyid" => key_id,
      "x-apple-cloudkit-request-iso8601date" => request_date,
      "x-apple-cloudkit-request-signaturev1" => sign_request!(private_key, payload)
    }
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

  defp request_date do
    DateTime.utc_now()
    |> DateTime.truncate(:second)
    |> DateTime.to_iso8601()
  end

  defp body_sha256(body) do
    :crypto.hash(:sha256, body) |> Base.encode64()
  end

  defp sign_request!(private_key, payload) do
    [pem_entry | _] = private_key |> :public_key.pem_decode()
    ec_private_key = :public_key.pem_entry_decode(pem_entry)

    :public_key.sign(payload, :sha256, ec_private_key)
    |> Base.encode64()
  end
end
