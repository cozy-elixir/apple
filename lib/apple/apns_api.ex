defmodule Apple.APNsAPI do
  @moduledoc """
  Utilities for [Apple Push Notification service](https://developer.apple.com/documentation/usernotifications).
  """

  alias Apple.JWT
  alias Apple.Types.APNs

  @doc "Builds a JWT to authorize APNs HTTP/2 requests."
  @spec build_auth_token!(APNs.team_id(), APNs.key_id(), APNs.private_key(), keyword()) ::
          String.t()
  def build_auth_token!(team_id, key_id, private_key, opts \\ [])
      when is_binary(team_id) and is_binary(key_id) and is_binary(private_key) do
    issued_at = JWT.unix_time_in_seconds()
    ttl_seconds = Keyword.get(opts, :ttl_seconds, 3600)

    header = %{"alg" => "ES256", "kid" => key_id, "typ" => "JWT"}
    claims = %{"iss" => team_id, "iat" => issued_at, "exp" => issued_at + ttl_seconds}

    JWT.sign_es256!(private_key, header, claims)
  end

  @spec production_url() :: String.t()
  def production_url, do: "https://api.push.apple.com"

  @spec development_url() :: String.t()
  def development_url, do: "https://api.sandbox.push.apple.com"
end
