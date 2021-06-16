defmodule Rfx.Change.CastTest do
  use ExUnit.Case

  alias Rfx.Change.Cast

  describe "#apply!" do
    test "with cl_file" do
      path = Tst.gen_file(":ok") 
      list = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
      result = list |> Cast.apply!()
      assert result 
      assert length(result) == 1
      assert result |> List.first() |> Map.get(:text_req) |> Map.get(:output_apply!)
    end
  end

  describe "#to_string" do
    test "with cl_file" do
      path = Tst.gen_file(":ok") 
      list = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
      result = list |> Cast.to_string() 
      assert result
      assert length(result) == 1
      assert result |> List.first() |> Map.get(:text_req) |> Map.get(:output_to_string)
    end
  end

end
