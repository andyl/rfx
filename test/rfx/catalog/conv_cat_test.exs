defmodule Rfx.Change.Convert.Blank3 do
end

defmodule Rfx.Catalog.ConvCatTest do

  use ExUnit.Case

  alias Rfx.Catalog.ConvCat

  describe "#raw_conv\1" do
    test "basic operation" do
      list = ConvCat.raw_conv()
      assert list 
      assert list |> length() > 1
      assert list |> Enum.member?(Rfx.Change.Convert.Blank3)
    end
  end

  describe "#all\0" do
    test "basic operation" do
      list = ConvCat.all_conv()
      assert list
      assert list |> length() > 1
      refute list |> Enum.member?(Rfx.Ops.Testop.Blank)
    end
  end

  describe "#select_conv\1" do
    test "with arg" do
      list = ConvCat.select_conv("Proto")
      assert list
      assert list |> length() == 0
    end
  end
end

