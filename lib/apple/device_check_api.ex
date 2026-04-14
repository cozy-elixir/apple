defmodule Apple.DeviceCheckAPI do
  @moduledoc """
  Utilities for [DeviceCheck API](https://developer.apple.com/documentation/devicecheck).

  DeviceCheck allows you to validate device tokens and query/update device state
  bits to detect fraudulent activity on iOS, tvOS, and macOS devices.
  """

  alias Apple.JWT
  alias Apple.Types.DeviceCheck

  @doc """
  Builds a token to authorize DeviceCheck HTTP requests.

  After building it, use it in the `Authorization` header like this:

  ```text
  Authorization: Bearer <JWT>
  ```

  ## More resources

    * [DeviceCheck API documentation](https://developer.apple.com/documentation/devicecheck)
    * [Accessing and Modifying Per-Device Data](https://developer.apple.com/documentation/devicecheck/accessing_and_modifying_per-device_data)

  """
  @spec build_auth_token!(
          DeviceCheck.issuer_id(),
          DeviceCheck.key_id(),
          DeviceCheck.private_key()
        ) ::
          String.t()
  def build_auth_token!(issuer_id, key_id, private_key)
      when is_binary(issuer_id) and
             is_binary(key_id) and
             is_binary(private_key) do
    issued_at = JWT.unix_time_in_seconds()

    # Expire the token after 1 hour (3600 seconds) as per Apple docs
    expired_at = issued_at + 3600

    header = %{
      "alg" => "ES256",
      "kid" => key_id,
      "typ" => "JWT"
    }

    payload = %{
      "iss" => issuer_id,
      "iat" => issued_at,
      "exp" => expired_at
    }

    JWT.sign_es256!(private_key, header, payload)
  end

  @doc """
  Returns the DeviceCheck API base URL for production.
  """
  @spec production_url() :: String.t()
  def production_url(), do: "https://api.devicecheck.apple.com"

  @doc """
  Returns the DeviceCheck API base URL for development.
  """
  @spec development_url() :: String.t()
  def development_url(), do: "https://api.development.devicecheck.apple.com"
end
