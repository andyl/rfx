defmodule Rfx.SourceTest do

  use ExUnit.Case

  alias Rfx.Util.Source

  describe "#diff" do
    test "creating a diff" do
      old = """
      a
      b
      """
      new = """
      a
      b
      c
      """
      expected = [%Diff.Insert{element: ["\n", "c"], index: 3, length: 2}]
      diff = Source.diff(old, new)

      assert diff == expected
    end
  end

  describe "#patch" do
    test "using a patch" do
      old = """
      a
      b
      """
      diff = [%Diff.Insert{element: ["\n", "c"], index: 3, length: 2}]
      expected = """
      a
      b
      c
      """
      new = Source.patch(old, diff)
      assert new == expected
    end
  end
end
