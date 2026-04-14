defmodule Apple.JWTTest do
  use ExUnit.Case, async: true

  test "sign_es256!/3 signs a compact JWT" do
    header = %{"alg" => "ES256", "kid" => "KEY123", "typ" => "JWT"}
    claims = %{"iss" => "TEAM123", "iat" => 1, "exp" => 2}

    jwt = Apple.JWT.sign_es256!(Apple.TestKey.pem(), header, claims)
    [header_b64, payload_b64, _signature] = String.split(jwt, ".")

    assert Base.url_decode64!(header_b64, padding: false) |> Jason.decode!() == header
    assert Base.url_decode64!(payload_b64, padding: false) |> Jason.decode!() == claims
  end
end
