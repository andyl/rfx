defmodule Rfx.Change.Request.TextReqTest do
  use ExUnit.Case

  alias Rfx.Change.Request.TextReq
  alias Rfx.Util.Tst

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

  describe "apply with file_path" do
    test "description" do
      path = Tst.gen_file(":ok") 
      text_req = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
               |> List.first()
               |> Map.get(:text_req)
      {:ok, message} = text_req |> TextReq.apply!() 
      assert message
    end
  end

  describe "apply with edit_source" do
    source = ":ok"
    text_req = Rfx.Ops.Proto.CommentAdd.cl_code(source) 
               |> List.first()
               |> Map.get(:text_req)
    {:error, message} = text_req |> TextReq.apply!() 
    assert message
  end
end
