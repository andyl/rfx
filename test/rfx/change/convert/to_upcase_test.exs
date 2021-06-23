defmodule Rfx.Change.Convert.ToUpcaseTest do

  use ExUnit.Case

  alias Rfx.Change.Convert.ToString
  alias Rfx.Change.Convert.ToUpcase
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
      result = req |> ToUpcase.changereq()  
      assert result 
      assert Map.get(result, :log)[:convert][:to_upcase]
    end

    test "idempotency" do
      path = Tst.gen_file(":ok") 
      req = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
            |> List.first() 
      result1 = req |> ToUpcase.changereq()  
      result2 = result1 |> ToUpcase.changereq()  
      assert result1 == result2
    end

    test "chained conversions" do
      path = Tst.gen_file(":ok") 
      req = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
            |> List.first() 
      result1 = req |> ToString.changereq()  
      result2 = result1 |> ToUpcase.changereq()  
      assert Map.get(result1, :log)[:convert][:to_string]
      refute Map.get(result1, :log)[:convert][:to_upcase]
      assert Map.get(result2, :log)[:convert][:to_string]
      assert Map.get(result2, :log)[:convert][:to_upcase]
    end
  end

end
