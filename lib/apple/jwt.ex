defmodule Apple.JWT do
  @moduledoc """
  Shared helpers for building Apple ES256 JWTs.
  """

  alias JOSE.{JWK, JWS, JWT}

  @spec sign_es256!(binary(), map(), map()) :: String.t()
  def sign_es256!(private_key, header, claims)
      when is_binary(private_key) and is_map(header) and is_map(claims) do
    jwk = JWK.from_pem(private_key)
    jws = JWS.from_map(header)
    jwt = JWT.from_map(claims)

    {_, token} = JWT.sign(jwk, jws, jwt) |> JWS.compact()
    token
  end

  @spec unix_time_in_seconds() :: integer()
  def unix_time_in_seconds do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
