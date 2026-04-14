defmodule Apple.CloudKitAPITest do
  use ExUnit.Case, async: true

  test "build_auth_token!/2 still returns a compact JWT" do
    jwt = Apple.CloudKitAPI.build_auth_token!("KEY456", Apple.TestKey.pem())
    assert length(String.split(jwt, ".")) == 3
  end

  test "signed_headers!/5 builds CloudKit request headers" do
    headers =
      Apple.CloudKitAPI.signed_headers!(
        "KEY456",
        Apple.TestKey.pem(),
        "/database/1/iCloud.com.example.app/production/public/records/query",
        ~s({"query":{"recordType":"Items"}}),
        request_date: "2026-04-14T12:00:00Z"
      )

    assert headers["x-apple-cloudkit-request-keyid"] == "KEY456"
    assert headers["x-apple-cloudkit-request-iso8601date"] == "2026-04-14T12:00:00Z"
    assert is_binary(headers["x-apple-cloudkit-request-signaturev1"])
    assert byte_size(Base.decode64!(headers["x-apple-cloudkit-request-signaturev1"])) > 0
  end

  test "database_url/3 includes database scope" do
    assert Apple.CloudKitAPI.database_url(:production, "iCloud.com.example.app", "public") ==
             "https://api.apple-cloudkit.com/database/1/iCloud.com.example.app/production/public"
  end
end
