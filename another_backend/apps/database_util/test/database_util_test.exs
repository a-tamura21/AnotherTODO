defmodule DatabaseUtilTest do
  use ExUnit.Case
  doctest DatabaseUtil

  test "greets the world" do
    assert DatabaseUtil.hello() == :world
  end
end
