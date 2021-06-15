defmodule Rfx.Change.ListTest do
  use ExUnit.Case

  alias Rfx.Change

  describe "#apply! with file_path" do
    test "description" do
      path = Tst.gen_file(":ok") 
      list = Rfx.Ops.Proto.CommentAdd.cl_file(file_path: path) 
      result = list |> Change.List.apply!()
      assert result 
      assert length(result) == 1
      assert result |> List.first() |> Map.get(:text_req) |> Map.get(:output_apply!)
    end
  end

  describe "#to_string with file_path" do
    test "description" do
      path = Tst.gen_file(":ok") 
      list = Rfx.Ops.Proto.CommentAdd.cl_file(file_path: path) 
      result = list |> Change.List.to_string() 
      assert result
      assert length(result) == 1
      assert result |> List.first() |> Map.get(:text_req) |> Map.get(:output_to_string)
    end
  end

end
