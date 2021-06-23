defmodule Rfx.Change.RequestTest do
  use ExUnit.Case

  alias Rfx.Change.Request
  alias Rfx.Util.Tst

  describe "#convert" do
    test "using to_string" do
      path = Tst.gen_file(":ok") 
      req = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
            |> List.first() 
      result = req |> Request.convert(:to_string) 
      assert result 
      assert Map.get(result, :log)[:convert][:to_string]
    end

    test "using to_upcase" do
      path = Tst.gen_file(":ok") 
      req = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
            |> List.first() 
      result = req |> Request.convert(:to_upcase) 
      assert result 
      assert Map.get(result, :log)[:convert][:to_upcase]
    end
  end

  describe "#apply!" do
    test "using cl_file" do
      path = Tst.gen_file(":ok") 
      req = Rfx.Ops.Proto.CommentAdd.cl_file(path) 
            |> List.first() 
      result = req |> Request.apply!()
      assert result 
      assert Map.get(result, :log)[:apply][:text]
      assert :ok == Map.get(result, :log)[:apply][:text] |> elem(0)
    end
  end

end
