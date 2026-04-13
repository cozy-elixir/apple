defmodule Apple.Types.AppleMusic do
  @moduledoc """
  Provides Apple Music API related types.
  """

  @typedoc """
  The private key ID for Apple Music API, like `"2Y9R5HMY68"`.

  To obtain the private key ID, sign into Apple Developer and complete the
  following steps:

    1. Navigate to "Certificates, IDs & Profiles".
    2. Navigate to "Keys".
    3. Generate a new key with MusicKit enabled.
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
  The Apple Music user token for accessing user-specific data (library, playlists).
  Obtained from the MusicKit framework on the client side.
  """
  @type user_token :: String.t()

  @typedoc """
  ISO 3166-1 alpha-2 country code for storefront, like `"US"`.
  """
  @type storefront :: String.t()

  @typedoc """
  Language tag for localization, like `"en-US"`.
  """
  @type language :: String.t()
end
