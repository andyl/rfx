defmodule Rfx.Change.Convert.ToDowncaseTest do

  use ExUnit.Case

  alias Rfx.Change.Convert.ToDowncase
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
      result = req |> ToDowncase.changereq()  
      assert result 
      assert Map.get(result, :log)[:convert][:to_downcase]
    end
  end

end
