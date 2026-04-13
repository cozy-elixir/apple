defmodule Apple.Types.DeviceCheck do
  @moduledoc """
  Provides DeviceCheck API related types.
  """

  @typedoc """
  The issuer ID (Team ID), which is a 10-character string, like `"6MPDV0UYYX"`

  To obtain the team ID, sign into Apple Developer and complete the following
  steps:

    1. Navigate to "Membership details".

  """
  @type issuer_id :: String.t()

  @typedoc """
  The private key ID for DeviceCheck, like `"2Y9R5HMY68"`.

  To obtain the private key ID, sign into Apple Developer and complete the
  following steps:

    1. Navigate to "Certificates, IDs & Profiles".
    2. Navigate to "Keys".
    3. Generate a new key with DeviceCheck enabled.
    4. Download the private key.

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
  The device token received from the device, base64-encoded.
  """
  @type device_token :: String.t()

  @typedoc """
  The transaction ID (UUID) for tracking requests.
  """
  @type transaction_id :: String.t()

  @typedoc """
  The timestamp for the request in milliseconds since 1970.
  """
  @type timestamp :: integer()

  @typedoc """
  Bit state for DeviceCheck (0 or 1 for each of two bits).
  """
  @type bit_state :: 0 | 1
end
