defmodule Apple.AppleDeveloperAPI do
  @moduledoc """
  Utilities for [Apple Developer API](https://developer.apple.com/documentation/appstoreconnectapi/profiles) via App Store Connect API.

  The Apple Developer API (via App Store Connect API endpoints) allows programmatic
  management of:

    * Certificates (CSR generation, download, revoke)
    * Provisioning profiles (create, download, manage devices)
    * Devices (register UDIDs for development)
    * Bundle IDs (app capabilities, push notifications)

  Note: These endpoints use the same App Store Connect API infrastructure but are
  specifically for developer account management, not app store operations.
  """

  alias JOSE.{JWK, JWS, JWT}
  alias Apple.Types.AppleDeveloper

  @doc """
  Builds a token to authorize Apple Developer API requests.

  Uses the same JWT mechanism as App Store Connect API. The token expires after
  20 minutes (maximum allowed for App Store Connect API).

  After building it, use it in the `Authorization` header like this:

  ```text
  Authorization: Bearer <JWT>
  ```

  ## More resources

    * [Creating API Keys for App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api)
    * [Profiles API](https://developer.apple.com/documentation/appstoreconnectapi/profiles)
    * [Certificates API](https://developer.apple.com/documentation/appstoreconnectapi/certificates)
    * [Devices API](https://developer.apple.com/documentation/appstoreconnectapi/devices)
    * [Bundle IDs API](https://developer.apple.com/documentation/appstoreconnectapi/bundle_ids)

  """
  @spec build_auth_token!(
          AppleDeveloper.team_id(),
          AppleDeveloper.key_id(),
          AppleDeveloper.private_key()
        ) ::
          String.t()
  def build_auth_token!(team_id, key_id, private_key)
      when is_binary(team_id) and
             is_binary(key_id) and
             is_binary(private_key) do
    issued_at = unix_time_in_seconds()

    # App Store Connect API tokens expire after 20 minutes maximum
    expired_at = issued_at + 1200

    header = %{
      "alg" => "ES256",
      "kid" => key_id,
      "typ" => "JWT"
    }

    payload = %{
      "iss" => team_id,
      "iat" => issued_at,
      "exp" => expired_at,
      "aud" => "appstoreconnect-v1"
    }

    jwk = JWK.from_pem(private_key)
    jws = JWS.from_map(header)
    jwt = JWT.from_map(payload)

    {_, token} = JWT.sign(jwk, jws, jwt) |> JWS.compact()
    token
  end

  @doc """
  Returns the App Store Connect API base URL.

  All Apple Developer API endpoints are hosted under this URL.
  """
  @spec base_url() :: String.t()
  def base_url(), do: "https://api.appstoreconnect.apple.com/v1"

  @doc """
  Returns the URL path for certificates resource.
  """
  @spec certificates_path() :: String.t()
  def certificates_path(), do: "/certificates"

  @doc """
  Returns the URL path for profiles resource.
  """
  @spec profiles_path() :: String.t()
  def profiles_path(), do: "/profiles"

  @doc """
  Returns the URL path for devices resource.
  """
  @spec devices_path() :: String.t()
  def devices_path(), do: "/devices"

  @doc """
  Returns the URL path for bundle IDs resource.
  """
  @spec bundle_ids_path() :: String.t()
  def bundle_ids_path(), do: "/bundleIds"

  @doc """
  Returns the URL path for a specific certificate.

  ## Examples

      iex> Apple.AppleDeveloperAPI.certificate_path("1234567890")
      "/certificates/1234567890"

  """
  @spec certificate_path(AppleDeveloper.certificate_id()) :: String.t()
  def certificate_path(certificate_id) when is_binary(certificate_id) do
    "/certificates/#{certificate_id}"
  end

  @doc """
  Returns the URL path for a specific profile.

  ## Examples

      iex> Apple.AppleDeveloperAPI.profile_path("1234567890")
      "/profiles/1234567890"

  """
  @spec profile_path(AppleDeveloper.profile_id()) :: String.t()
  def profile_path(profile_id) when is_binary(profile_id) do
    "/profiles/#{profile_id}"
  end

  @doc """
  Returns the URL path for a specific device.

  ## Examples

      iex> Apple.AppleDeveloperAPI.device_path("1234567890")
      "/devices/1234567890"

  """
  @spec device_path(AppleDeveloper.device_id()) :: String.t()
  def device_path(device_id) when is_binary(device_id) do
    "/devices/#{device_id}"
  end

  @doc """
  Returns the URL path for a specific bundle ID.

  ## Examples

      iex> Apple.AppleDeveloperAPI.bundle_id_path("com.example.app")
      "/bundleIds/com.example.app"

  """
  @spec bundle_id_path(AppleDeveloper.bundle_id()) :: String.t()
  def bundle_id_path(bundle_id) when is_binary(bundle_id) do
    "/bundleIds/#{bundle_id}"
  end

  defp unix_time_in_seconds() do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
