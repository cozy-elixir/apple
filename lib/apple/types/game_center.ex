defmodule Apple.Types.GameCenter do
  @moduledoc """
  Provides Game Center API related types.
  """

  @typedoc """
  The issuer ID (Team ID), which is a 10-character string, like `"6MPDV0UYYX"`

  To obtain the team ID, sign into Apple Developer and complete the following
  steps:

    1. Navigate to "Membership details".

  """
  @type team_id :: String.t()

  @typedoc """
  The private key ID for Game Center API, like `"2Y9R5HMY68"`.

  To obtain the private key ID, sign into Apple Developer and complete the
  following steps:

    1. Navigate to "Certificates, IDs & Profiles".
    2. Navigate to "Keys".
    3. Generate a new key with Game Center enabled.
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
  The app's bundle ID, like `"com.example.game"`.
  """
  @type bundle_id :: String.t()

  @typedoc """
  A player ID in Game Center.
  """
  @type player_id :: String.t()

  @typedoc """
  A leaderboard ID.
  """
  @type leaderboard_id :: String.t()

  @typedoc """
  An achievement ID.
  """
  @type achievement_id :: String.t()
end
