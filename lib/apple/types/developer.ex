defmodule Apple.Types.Developer do
  @moduledoc """
  Provides Apple Developer related types.
  """

  @typedoc """
  The team ID, which is a 10-character string, like `"6MPDV0UYYX"`

  To obtain the team ID, sign into Apple Developer and complete the following
  steps:

    1. Navigate to "Membership details".

  """
  @type team_id :: String.t()

  @typedoc """
  The private key ID, like `"2Y9R5HMY68"`.

  To obtain the private key ID, sign into Apple Developer and complete the
  following steps:

    1. Navigate to "Certificates, IDs & Profiles".
    2. Navigate to "Keys".
    3. Click the plus button to generate a new private key.

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
  The registered service ID, like `"com.example.weatherkit"`.

  To obtain the registered service ID, sign into Apple Developer and complete
  the following steps:

    1. Navigate to "Certificates, IDs & Profiles".
    2. Navigate to "Identifiers".
    3. Click the plus button to add a new identifier.
    4. Select "Service IDs", and register a service ID.

  """
  @type service_id :: String.t()
end
