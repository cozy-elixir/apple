defmodule Apple.BusinessConnectAPI do
  @moduledoc """
  Low-level auth helpers for Apple Business Connect and related Apple business OAuth flows.

  Apple Business Connect onboarding varies between OAuth apps and service accounts,
  so this module focuses on token-building primitives instead of a full API client.
  """

  alias Apple.JWT
  alias Apple.Types.BusinessConnect

  @token_url "https://account.apple.com/auth/oauth2/v2/token"

  @spec token_url() :: String.t()
  def token_url, do: @token_url

  @doc "Builds form params for a service-account client-credentials token request."
  @spec service_account_token_params(
          BusinessConnect.client_id(),
          BusinessConnect.client_secret(),
          keyword()
        ) :: map()
  def service_account_token_params(client_id, client_secret, opts \\ [])
      when is_binary(client_id) and is_binary(client_secret) do
    %{
      "grant_type" => Keyword.get(opts, :grant_type, "client_credentials"),
      "client_id" => client_id,
      "client_secret" => client_secret,
      "scope" => Keyword.get(opts, :scope, "business.api")
    }
  end

  @doc "Builds a client assertion JWT for Apple business OAuth exchanges."
  @spec build_client_assertion!(
          String.t(),
          String.t(),
          String.t(),
          BusinessConnect.client_id(),
          keyword()
        ) :: String.t()
  def build_client_assertion!(team_id, key_id, private_key, client_id, opts \\ [])
      when is_binary(team_id) and is_binary(key_id) and is_binary(private_key) and
             is_binary(client_id) do
    issued_at = JWT.unix_time_in_seconds()
    ttl_seconds = Keyword.get(opts, :ttl_seconds, 3600)
    audience = Keyword.get(opts, :audience, @token_url)

    header = %{"alg" => "ES256", "kid" => key_id, "typ" => "JWT"}

    claims = %{
      "iss" => team_id,
      "sub" => client_id,
      "iat" => issued_at,
      "exp" => issued_at + ttl_seconds,
      "aud" => audience
    }

    claims =
      case Keyword.get(opts, :jti) do
        nil -> claims
        jti -> Map.put(claims, "jti", jti)
      end

    JWT.sign_es256!(private_key, header, claims)
  end

  @doc "Builds form params for a client-assertion token request."
  @spec client_assertion_token_params(BusinessConnect.client_id(), String.t(), keyword()) :: map()
  def client_assertion_token_params(client_id, client_assertion, opts \\ [])
      when is_binary(client_id) and is_binary(client_assertion) do
    %{
      "grant_type" => Keyword.get(opts, :grant_type, "client_credentials"),
      "client_id" => client_id,
      "client_assertion_type" =>
        Keyword.get(
          opts,
          :client_assertion_type,
          "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
        ),
      "client_assertion" => client_assertion,
      "scope" => Keyword.get(opts, :scope, "business.api")
    }
  end

  @spec form_urlencoded_body(map()) :: String.t()
  def form_urlencoded_body(params) when is_map(params) do
    URI.encode_query(params)
  end
end
