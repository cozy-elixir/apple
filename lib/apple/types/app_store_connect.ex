defmodule Apple.Types.AppStoreConnect do
  @moduledoc """
  Provides App Store Connect related types.
  """

  @typedoc """
  The issuer ID, like `"57246542-96fe-1a63-e053-0824d011072a"`

  To obtain the issuer ID, sign into App Store Connect and complete the
  following steps:

    1. Select "Users and Access", and then select the "Integrations" tab.
    2. Select the type of "Keys" that you need:
       - App Store Connect API
       - In-App Purchase
    3. Look up the "Issue ID" on the page.

  """
  @type issuer_id :: String.t()

  @typedoc """
  The app's bundle ID, like `"com.example.demo"`.

  To obtain the app's bundle ID, sign into App Store Connect and complete the
  following steps:

    1. Select "Apps".
    2. Select "App Information" under the "General" section.
    3. Look up the "Bundle ID" on the page.

  """
  @type bundle_id :: String.t()

  @typedoc """
  The private key ID, like `"2X9R4HXF34"`.

  To generate a private key, sign into App Store Connect and complete the
  following steps:

    1. Select "Users and Access", and then select the "Integrations" tab.
    2. Select the type of "Keys" that you need:
       - App Store Connect API
       - In-App Purchase
    3. Click the Generate button or the Add (+) button.
    4. Enter a name for the key.
    5. Click the Generate button.

  Then, following information appears on the page:

    * the private key's name
    * the private key ID
    * the link for downloading the private key

  > #### Note {: .info}
  > The name for the key is for your reference only and isn't part of the key itself.

  > #### Warning {: .warning}
  > The private key is only available for download a single time.

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
  The secret for verifying receipt, which is a 32-character hexadecimal string,
  like `"10e87024b8b34e699156d1d89bdd6bf0"`.

  There are two type of shared secrets:

    * primary shared secret, which can be used for all of your apps.
    * app-specific shared secret, which can only be used for individual apps.

  To obtain a primary shared secret, sign into App Store Connect and complete
  the following steps:

    1. Select "Users and Access", and then select the "Integrations" tab.
    2. Select the "Shared Secret" type of "Keys".
    3. Generate or regenerate a shared secret.

  To obtain a app-specific shared secret, sign into App Store Connect and
  complete the following steps:

    1. Select "Apps".
    2. Select the app that you want to generate shared secret for.
    3. Select "App Information" under the "General" section.
    4. Look up "App-Specific Shared Secret" on the page.

  > #### Note {: .info}
  >
  > Considering that App Store Receipts have been deprecated, this so-called
  > shared secret should no longer be used.

  """
  @type shared_secret :: String.t()
end
