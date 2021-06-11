defmodule Rfx.Change.Req.TextReqTest do
  use ExUnit.Case

  alias Rfx.Change.Req.TextReq

  # ----- Construction -----
  
  describe "file constructor" do
    test "returns :ok with valid file" do
      path = Tst.gen_file("content ok")
      diff = "diff ok"
      assert {:ok, result} = TextReq.new(file_path: path, diff: diff)
      assert result == %{file_path: path, diff: diff}
    end

    test "returns :error with missing file" do
      path = "/tmp/missing.ex"
      diff = "diff ok"
      assert {:error, _} = TextReq.new(file_path: path, diff: diff)
    end
  end

  describe "source constructor" do
    test "returns :ok" do
      content = "content ok"
      diff = "diff ok"
      assert {:ok, result} = TextReq.new(edit_source: content, diff: diff)
      assert result == %{edit_source: content, diff: diff}
    end
  end
  
  # ----- Conversion -----
  
  # ----- Application -----

end
