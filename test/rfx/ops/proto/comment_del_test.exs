defmodule Rfx.Ops.Proto.CommentDelTest do
  use ExUnit.Case

  alias Rfx.Ops.Proto.CommentDel
  alias Rfx.Util.Source
  alias Rfx.Util.Tst

  @base_source """
  # TestComment
  x = 1
  """

  @base_expected """
  x = 1
  """ 

  @base_diff """
  1d0
  < # TestComment
  """ 

  doctest CommentDel

  describe "#cl_code with source code" do
    test "changelist length" do
      changelist = CommentDel.cl_code(@base_source)
      assert [_single_item] = changelist
    end

    test "expected fields" do
      [changereq | _] = CommentDel.cl_code(@base_source)
      refute changereq |> Map.get(:file_req)
      assert changereq |> Map.get(:text_req)
      assert changereq |> Map.get(:text_req) |> Map.get(:diff)
      assert changereq |> Map.get(:text_req) |> Map.get(:input_text)
    end

    test "diff generation" do
      [changereq | _] = CommentDel.cl_code(@base_source)
      diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
      assert diff == @base_diff
    end

    test "patching" do
      [changereq | _] = CommentDel.cl_code(@base_source)
      code = Map.get(changereq, :text_req) |> Map.get(:input_text)
      diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
      new_code = Source.patch(code, diff)
      assert new_code == @base_expected
    end
  end

  describe "#cl_code with source file" do
    test "changelist length" do
      file = Tst.gen_file(@base_source)
      changelist = CommentDel.cl_file(file)
      assert [_single_item] = changelist
    end

    test "expected fields for source file" do
      file = Tst.gen_file(@base_source)
      [changereq | _] = CommentDel.cl_file(file)
      refute changereq |> Map.get(:file_req)
      assert changereq |> Map.get(:text_req)
      assert changereq |> Map.get(:text_req) |> Map.get(:diff)
      assert changereq |> Map.get(:text_req) |> Map.get(:input_file)
    end

    test "diff generation" do
      file = Tst.gen_file(@base_source)
      [changereq | _] = CommentDel.cl_file(file)
      diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
      assert diff == @base_diff
    end


    test "patching" do
      file = Tst.gen_file(@base_source)
      [changereq | _] = CommentDel.cl_file(file)
      code = Map.get(changereq, :text_req) |> Map.get(:input_file) |> File.read() |> elem(1)
      diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
      new_code = Source.patch(code, diff)
      assert new_code == @base_expected
    end
  end

  describe "#cl_file with source file" do
    test "changelist length" do
      file = Tst.gen_file(@base_source)
      changelist = CommentDel.cl_file(file)
      assert [_single_item] = changelist
    end

    test "changereq fields" do
      file = Tst.gen_file(@base_source)
      [changereq| _ ] = CommentDel.cl_file(file)
      refute changereq |> Map.get(:file_req)
      assert changereq |> Map.get(:text_req)
      assert changereq |> Map.get(:text_req) |> Map.get(:diff)
      assert changereq |> Map.get(:text_req) |> Map.get(:input_file)
    end

    test "diff generation" do
      file = Tst.gen_file(@base_source)
      [changereq | _] = CommentDel.cl_file(file)
      diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
      assert diff == @base_diff
    end

    test "patching" do
      file = Tst.gen_file(@base_source)
      [changereq | _] = CommentDel.cl_file(file)
      code = Map.get(changereq, :text_req) |> Map.get(:input_file) |> File.read() |> elem(1)
      diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
      new_code = Source.patch(code, diff)
      assert new_code == @base_expected
    end
  end

  describe "#cl_file with keyword list" do
    test "changelist length" do
      file = Tst.gen_file(@base_source)
      changelist = CommentDel.cl_file(file)
      assert [_single_item] = changelist
    end
  end

  describe "#cl_project!" do
    test "changelist length" do
      root_dir = Tst.gen_proj("mix new")
      changelist = CommentDel.cl_project(root_dir)
      assert Enum.empty?(changelist) 
    end
  end
end
