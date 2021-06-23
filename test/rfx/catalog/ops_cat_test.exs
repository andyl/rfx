defmodule Rfx.Ops.Testop.Blank2 do
end

defmodule Rfx.Catalog.OpsCatTest do

  use ExUnit.Case

  alias Rfx.Catalog.OpsCat

  describe "#raw_ops\1" do
    test "basic operation" do
      list = OpsCat.raw_ops()
      assert list 
      assert list |> length() > 1
      assert list |> Enum.member?(Rfx.Ops.Testop.Blank2)
    end
  end

  describe "#all\0" do
    test "basic operation" do
      list = OpsCat.all_ops()
      assert list
      assert list |> length() > 1
      refute list |> Enum.member?(Rfx.Ops.Testop.Blank2)
    end
  end

  describe "#select_ops\1" do
    test "without arg" do
      list = OpsCat.select_ops()
      assert list
      assert list |> length() > 1
      refute list |> Enum.member?(Rfx.Ops.Testop.Blank2)
    end

    test "with arg" do
      list = OpsCat.select_ops("Proto")
      assert list
      assert list |> length() == 4
    end
  end
end

