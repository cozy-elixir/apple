defmodule Apple.APNsAPITest do
  use ExUnit.Case, async: true

  test "build_auth_token!/4 signs a valid APNs JWT" do
    jwt =
      Apple.APNsAPI.build_auth_token!(
        "TEAM123",
        "KEY456",
        Apple.TestKey.pem(),
        ttl_seconds: 120
      )

    [header_b64, payload_b64, _signature] = String.split(jwt, ".")
    header = Base.url_decode64!(header_b64, padding: false) |> Jason.decode!()
    payload = Base.url_decode64!(payload_b64, padding: false) |> Jason.decode!()

    assert header["kid"] == "KEY456"
    assert payload["iss"] == "TEAM123"
    assert payload["exp"] - payload["iat"] == 120
  end

  test "returns APNs URLs" do
    assert Apple.APNsAPI.production_url() == "https://api.push.apple.com"
    assert Apple.APNsAPI.development_url() == "https://api.sandbox.push.apple.com"
  end
end
