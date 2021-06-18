defmodule Rfx.Change.ReqTest do
  use ExUnit.Case

  alias Rfx.Change.Req
  alias Rfx.Util.Tst

  describe "#apply!" do
    test "using cl_file" do
      path = Tst.gen_file(":ok") 
      req = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
            |> List.first() 
      result = req |> Req.apply!()
      assert result
      assert Map.get(result, :text_req)[:output_apply!]
      assert :ok == Map.get(result, :text_req)[:output_apply!] |> elem(0)
    end
  end

  describe "#to_string" do
    test "using cl_file" do
      path = Tst.gen_file(":ok") 
      req = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
            |> List.first() 
      result = req |> Req.to_string()  
      assert result
      assert Map.get(result, :text_req)[:output_to_string]
    end
  end

  describe "chaining helpers" do
    test "using cl_file" do
      path = Tst.gen_file(":ok") 
      req = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
            |> List.first() 
      result = req |> Req.to_string() |> Req.apply!()
      assert result 
      assert Map.get(result, :text_req)[:output_to_string]
      assert Map.get(result, :text_req)[:output_apply!]
    end
  end

end
