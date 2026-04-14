defmodule Apple.BusinessConnectAPITest do
  use ExUnit.Case, async: true

  test "service_account_token_params/3 builds client-credentials request" do
    params =
      Apple.BusinessConnectAPI.service_account_token_params("client-id", "secret",
        scope: "business.api"
      )

    assert params == %{
             "grant_type" => "client_credentials",
             "client_id" => "client-id",
             "client_secret" => "secret",
             "scope" => "business.api"
           }
  end

  test "build_client_assertion!/5 signs expected claims" do
    jwt =
      Apple.BusinessConnectAPI.build_client_assertion!(
        "TEAM123",
        "KEY456",
        Apple.TestKey.pem(),
        "business.client",
        ttl_seconds: 120,
        jti: "abc-123"
      )

    [header_b64, payload_b64, _signature] = String.split(jwt, ".")
    header = Base.url_decode64!(header_b64, padding: false) |> Jason.decode!()
    payload = Base.url_decode64!(payload_b64, padding: false) |> Jason.decode!()

    assert header["kid"] == "KEY456"
    assert payload["iss"] == "TEAM123"
    assert payload["sub"] == "business.client"
    assert payload["aud"] == "https://account.apple.com/auth/oauth2/v2/token"
    assert payload["jti"] == "abc-123"
    assert payload["exp"] - payload["iat"] == 120
  end

  test "client_assertion_token_params/3 builds JWT-bearer request" do
    params = Apple.BusinessConnectAPI.client_assertion_token_params("client-id", "jwt-token")

    assert params["grant_type"] == "client_credentials"
    assert params["client_id"] == "client-id"
    assert params["client_assertion"] == "jwt-token"

    assert params["client_assertion_type"] ==
             "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"

    assert params["scope"] == "business.api"
  end

  test "form_urlencoded_body/1 encodes params" do
    body =
      Apple.BusinessConnectAPI.form_urlencoded_body(%{
        "client_id" => "a",
        "scope" => "business.api"
      })

    assert body == "client_id=a&scope=business.api"
  end

  test "token_url/0 returns oauth endpoint" do
    assert Apple.BusinessConnectAPI.token_url() ==
             "https://account.apple.com/auth/oauth2/v2/token"
  end
end
