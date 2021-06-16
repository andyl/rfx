defmodule Rfx.CatalogTest do
  use ExUnit.Case

  describe "#all\1" do
    test "basic operation" do
      list = Rfx.Catalog.all()
      assert list
      assert list |> length() > 1
    end
  end

end

