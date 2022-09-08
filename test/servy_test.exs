defmodule ServyTest do
  use ExUnit.Case
  doctest Servy

  #refute är motsattsen av assert den testar om något inte stämmer

  test "greets the world" do
    assert Servy.hello() == :world
  end
end
