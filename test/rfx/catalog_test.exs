defmodule Rfx.Ops.Testop.Blank do
end

defmodule Rfx.CatalogTest do

  use ExUnit.Case

  describe "#raw_ops\1" do
    test "basic operation" do
      list = Rfx.Catalog.raw_ops()
      assert list 
      assert list |> length() > 1
      assert list |> Enum.member?(Rfx.Ops.Testop.Blank)
    end
  end

  describe "#all\0" do
    test "basic operation" do
      list = Rfx.Catalog.all()
      assert list
      assert list |> length() > 1
      refute list |> Enum.member?(Rfx.Ops.Testop.Blank)
    end
  end

  describe "#select\1" do
    test "without arg" do
      list = Rfx.Catalog.select()
      assert list
      assert list |> length() > 1
      refute list |> Enum.member?(Rfx.Ops.Testop.Blank)
    end

    test "with arg" do
      list = Rfx.Catalog.select("Proto")
      assert list
      assert list |> length() == 3
    end
  end
end

