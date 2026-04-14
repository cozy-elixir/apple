defmodule Apple.TestKey do
  @moduledoc false

  @spec pem() :: String.t()
  def pem do
    private_key = JOSE.JWK.generate_key({:ec, "P-256"})
    JOSE.JWK.to_pem(private_key) |> elem(1)
  end
end
