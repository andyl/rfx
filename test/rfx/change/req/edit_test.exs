defmodule Rfx.Change.Req.EditTest do
  use ExUnit.Case

  alias Rfx.Change.Req.Edit

  # ----- Construction -----
  
  describe "file constructor" do
    @tag :pending
    test "returns :ok with valid file" do
      path = Tst.gen_file("content ok")
      diff = "diff ok"
      assert {:ok, result} = Edit.new(file_path: path, diff: diff)
      assert result == %{file_path: path, diff: diff}
    end

    @tag :pending
    test "returns :error with missing file" do
      path = "/tmp/missing.ex"
      diff = "diff ok"
      assert {:error, _} = Edit.new(file_path: path, diff: diff)
    end
  end

  describe "source constructor" do
    @tag :pending
    test "returns :ok" do
      content = "content ok"
      diff = "diff ok"
      assert {:ok, result} = Edit.new(edit_source: content, diff: diff)
      assert result == %{edit_source: content, diff: diff}
    end
  end
  
  # ----- Conversion -----
  
  # ----- Application -----

end
