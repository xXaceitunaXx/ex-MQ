defmodule ExMqTest do
  use ExUnit.Case
  doctest ExMq

  test "greets the world" do
    assert ExMq.hello() == :world
  end
end
