defmodule Rfx.Change.Convert.ToStringTest do

  use ExUnit.Case

  alias Rfx.Change.Convert.ToString
  alias Rfx.Util.Tst

  # describe "#apply!" do
  #   test "using cl_file" do
  #     path = Tst.gen_file(":ok") 
  #     req = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
  #           |> List.first() 
  #     result = req |> Req.apply!()
  #     assert result
  #     assert Map.get(result, :text_req)[:output_apply!]
  #     assert :ok == Map.get(result, :text_req)[:output_apply!] |> elem(0)
  #   end
  # end

  describe "#changereq" do
    test "using cl_file" do
      path = Tst.gen_file(":ok") 
      req = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
            |> List.first() 
      result = req |> ToString.changereq()  
      assert result 
      assert Map.get(result, :log)[:convert][:to_string]
    end

    test "idempotency" do
      path = Tst.gen_file(":ok") 
      req = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
            |> List.first() 
      result1 = req |> ToString.changereq()  
      result2 = result1 |> ToString.changereq()  
      assert result1 == result2
    end
  end

end
