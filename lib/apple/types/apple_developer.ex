defmodule Apple.Types.AppleDeveloper do
  @moduledoc """
  Provides Apple Developer API related types.

  The Apple Developer API allows programmatic management of:

    * Certificates (development, distribution, push notification)
    * Provisioning profiles
    * Devices
    * App IDs and capabilities
    * Users and roles

  """

  @typedoc """
  The issuer ID (Team ID), which is a 10-character string, like `"6MPDV0UYYX"`

  To obtain the team ID, sign into Apple Developer and complete the following
  steps:

    1. Navigate to "Membership details".

  """
  @type team_id :: String.t()

  @typedoc """
  The private key ID for Apple Developer API, like `"2Y9R5HMY68"`.

  To obtain the private key ID, sign into App Store Connect and complete the
  following steps:

    1. Select "Users and Access", and then select the "Integrations" tab.
    2. Select "Keys" type "App Store Connect API".
    3. Click the Generate button or the Add (+) button.
    4. Enter a name for the key.
    5. Click the Generate button.
    6. Download the private key.

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

  > #### Warning {: .warning}
  > The private key is only available for download a single time.

  """
  @type private_key :: String.t()

  @typedoc """
  A certificate ID, like `"1234567890"`.
  """
  @type certificate_id :: String.t()

  @typedoc """
  A provisioning profile ID, like `"1234567890"`.
  """
  @type profile_id :: String.t()

  @typedoc """
  A device ID (UDID), like `"1234567890abcdef1234567890abcdef12345678"`.
  """
  @type device_id :: String.t()

  @typedoc """
  An App ID (bundle identifier), like `"com.example.app"`.
  """
  @type bundle_id :: String.t()

  @typedoc """
  Certificate types for filtering.

  Possible values:

    * `"IOS_DEVELOPMENT"` - iOS Development
    * `"IOS_DISTRIBUTION"` - iOS Distribution
    * `"MAC_APP_DEVELOPMENT"` - Mac App Development
    * `"MAC_APP_DISTRIBUTION"` - Mac App Distribution
    * `"MAC_INSTALLER_DISTRIBUTION"` - Mac Installer Distribution
    * `"DEVELOPMENT"` - Development (universal)
    * `"DISTRIBUTION"` - Distribution (universal)
    * `"PASS_TYPE_ID"` - Pass Type ID Certificate
    * `"PASS_TYPE_ID_WITH_NFC"` - Pass Type ID Certificate with NFC

  """
  @type certificate_type :: String.t()

  @typedoc """
  Profile types for filtering.

  Possible values:

    * `"IOS_APP_DEVELOPMENT"` - iOS App Development
    * `"IOS_APP_STORE"` - iOS App Store
    * `"IOS_APP_ADHOC"` - iOS App Ad Hoc
    * `"IOS_APP_INHOUSE"` - iOS App In House
    * `"MAC_APP_DEVELOPMENT"` - Mac App Development
    * `"MAC_APP_STORE"` - Mac App Store
    * `"MAC_APP_DIRECT"` - Mac App Direct
    * `"TVOS_APP_DEVELOPMENT"` - tvOS App Development
    * `"TVOS_APP_STORE"` - tvOS App Store
    * `"TVOS_APP_ADHOC"` - tvOS App Ad Hoc
    * `"TVOS_APP_INHOUSE"` - tvOS App In House
    * `"MAC_CATALYST_APP_DEVELOPMENT"` - Mac Catalyst App Development
    * `"MAC_CATALYST_APP_STORE"` - Mac Catalyst App Store
    * `"MAC_CATALYST_APP_DIRECT"` - Mac Catalyst App Direct

  """
  @type profile_type :: String.t()

  @typedoc """
  Device status for filtering.

  Possible values:

    * `"ENABLED"` - Device is enabled for development
    * `"DISABLED"` - Device is disabled

  """
  @type device_status :: String.t()

  @typedoc """
  Device class for filtering.

  Possible values:

    * `"IPHONE"` - iPhone
    * `"IPAD"` - iPad
    * `"IPOD"` - iPod touch
    * `"APPLE_TV"` - Apple TV
    * `"APPLE_WATCH"` - Apple Watch
    * `"MAC"` - Mac

  """
  @type device_class :: String.t()
end
