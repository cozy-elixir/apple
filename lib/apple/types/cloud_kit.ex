defmodule Apple.Types.CloudKit do
  @moduledoc """
  Provides CloudKit API related types.
  """

  @typedoc """
  The container identifier, like `"iCloud.com.example.myapp"`.

  To obtain the container identifier:

    1. Sign into Apple Developer.
    2. Navigate to "Certificates, IDs & Profiles".
    3. Navigate to "Identifiers".
    4. Look for iCloud containers or App IDs with CloudKit enabled.

  """
  @type container_id :: String.t()

  @typedoc """
  The CloudKit database to use: `"public"`, `"private"`, or `"shared"`.
  """
  @type database :: String.t()

  @typedoc """
  The key ID for CloudKit Server-to-Server authentication, like `"2Y9R5HMY68"`.

  To obtain the key ID:

    1. Sign into Apple Developer.
    2. Navigate to "Certificates, IDs & Profiles".
    3. Navigate to "Keys".
    4. Generate a new key with CloudKit enabled.
    5. Download the private key.

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
  A CloudKit record ID.
  """
  @type record_id :: String.t()

  @typedoc """
  A CloudKit record type (like a table name).
  """
  @type record_type :: String.t()

  @typedoc """
  CloudKit environment: `:development` or `:production`.
  """
  @type environment :: :development | :production
end
