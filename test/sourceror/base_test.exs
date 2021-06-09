defmodule Sourceror.BaseTest do

  use ExUnit.Case

  describe "basic conversion tests" do
    test "between AST and String" do
      str = "x = 2 + 4"
      out = str |> Sourceror.parse_string() |> elem(1) |> Sourceror.to_string() 
      assert str == out
    end
  end
end
