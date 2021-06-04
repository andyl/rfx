defmodule Rfx.Changereq.EditTest do
  use ExUnit.Case

  alias Rfx.Changereq.Edit

  # ----- Construction -----
  
  describe "file constructor" do
    test "returns :ok with valid file" do
      path = Tst.gen_file("content ok")
      diff = "diff ok"
      assert {:ok, result} = Edit.new(edit_file: path, diff: diff)
      assert result == %Rfx.Changereq.Edit{edit_file: path, diff: diff}
    end

    test "returns :error with missing file" do
      path = "/tmp/missing.ex"
      diff = "diff ok"
      assert {:error, _} = Edit.new(edit_file: path, diff: diff)
    end
  end

  describe "source constructor" do
    test "returns :ok" do
      content = "content ok"
      diff = "diff ok"
      assert {:ok, result} = Edit.new(edit_source: content, diff: diff)
      assert result == %Edit{edit_source: content, diff: diff}
    end
  end
  
  # ----- Conversion -----
  
  # ----- Application -----

end
