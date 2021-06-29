defmodule Rfx.Change.Request.TextReqTest do
  use ExUnit.Case

  alias Rfx.Change.Request.TextReq
  alias Rfx.Util.Tst

  # ----- Construction -----

  describe "file constructor" do
    test "returns :ok with valid file" do
      path = Tst.gen_file("content ok")
      diff = "diff ok"
      assert {:ok, result} = TextReq.new(input_file: path, diff: diff)
      assert result == %{input_file: path, diff: diff}
    end

    test "returns :error with missing file" do
      path = "/tmp/missing.ex"
      diff = "diff ok"
      assert %{error: _} = TextReq.new(input_file: path, diff: diff)
    end
  end

  describe "source constructor" do
    test "returns :ok" do
      content = "content ok"
      diff = "diff ok"
      assert {:ok, result} = TextReq.new(input_text: content, diff: diff)
      assert result == %{input_text: content, diff: diff}
    end
  end
  
  # ----- Conversion -----
  
  # ----- Application -----

  describe "apply with input_file" do
    test "description" do
      path = Tst.gen_file(":ok") 
      text_req = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
               |> List.first()
               |> Map.get(:text_req)
      {:ok, message} = text_req |> TextReq.apply!() 
      assert message
    end
  end

  describe "apply with input_text" do
    source = ":ok"
    text_req = Rfx.Ops.Proto.CommentAdd.cl_code(source) 
               |> List.first()
               |> Map.get(:text_req)
    %{error: message} = text_req |> TextReq.apply!() 
    assert message
  end
end
