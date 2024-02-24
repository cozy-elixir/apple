defmodule AppleTest do
  use ExUnit.Case
  doctest Apple

  test "greets the world" do
    assert Apple.hello() == :world
  end
end
