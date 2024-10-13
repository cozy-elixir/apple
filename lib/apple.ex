defmodule Apple do
  @moduledoc """
  Utilities for building Apple SDKs.

  > #### Note {: .info}
  >
  > This is not a one-stop, comprehensive SDK. As the description implies, it
  > provides utilities for building your own minimalistic and focused SDK.
  >
  > Read more about this idea at [Ship utilities for building platform SDKs](https://github.com/cozy-elixir/proposals/blob/main/ship-utilities-for-building-platform-sdks.md).
  """

  @typedoc """
  The team ID, which is a 10-character string, like `"6MPDV0UYYX"`

  It can be obtained from your Apple Developer account by following this path:

    1. Sign into your Apple Developer account.
    2. Navigate to "Membership details".

  """
  @type team_id :: String.t()

  @typedoc """
  The private key ID, like `"2Y9R5HMY68"`.

  It can be obtained from your Apple Developer account by following this path:

    1. Sign into your Apple Developer account.
    2. Navigate to "Certificates, IDs & Profiles".
    3. Navigate to "Keys".
    4. Click the plus button to add a new key.

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
end
