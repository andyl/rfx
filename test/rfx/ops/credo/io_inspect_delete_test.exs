defmodule Rfx.Ops.Credo.IoInspectDeleteTest do
  use ExUnit.Case

  alias Rfx.Ops.Credo.IoInspectDelete
  alias Rfx.Util.Source
  alias Rfx.Util.Tst

  @base_source """
  asdf() |> IO.inspect() |> qwer()
  """

  @base_expected """
  asdf() |> qwer()
  """ 

  describe "#rfx_code" do
    test "expected fields" do
      [changereq | _] = IoInspectDelete.cl_code(@base_source)
      refute changereq |> Map.get(:file_req)
      assert changereq |> Map.get(:text_req)
      assert changereq |> Map.get(:text_req) |> Map.get(:diff)
      assert changereq |> Map.get(:text_req) |> Map.get(:input_text)
    end

    test "diff generation" do
      [changereq | _] = IoInspectDelete.cl_code(@base_source)
      diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
      assert diff 
    end

    test "patching" do
      [changereq | _] = IoInspectDelete.cl_code(@base_source)
      code = Map.get(changereq, :text_req) |> Map.get(:input_text)
      diff = Map.get(changereq, :text_req) |> Map.get(:diff)
      new_code = Source.patch(code, diff)
      assert new_code == @base_expected
    end

    test "no change required source" do
      changeset = IoInspectDelete.cl_code(@base_expected) 
      assert changeset == []
    end

  end

  describe "#rfx_file! with source file" do
    test "changeset length" do
      file = Tst.gen_file(@base_source)
      changeset = IoInspectDelete.cl_file(file)
      assert [_single_item] = changeset
    end

    test "changereq fields" do
      file = Tst.gen_file(@base_source)
      [changereq| _ ] = IoInspectDelete.cl_file(file)
      refute changereq |> Map.get(:file_req)
      assert changereq |> Map.get(:text_req)
      assert changereq |> Map.get(:text_req) |> Map.get(:diff)
      assert changereq |> Map.get(:text_req) |> Map.get(:input_file)
    end

    test "diff generation" do
      file = Tst.gen_file(@base_source)
      [changereq | _] = IoInspectDelete.cl_file(file)
      diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
      assert diff 
    end

    test "patching" do
      file = Tst.gen_file(@base_source)
      [changereq | _] = IoInspectDelete.cl_file(file)
      code = Map.get(changereq, :text_req) |> Map.get(:input_file) |> File.read() |> elem(1)
      diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
      new_code = Source.patch(code, diff)
      assert new_code == @base_expected
    end
  end

  describe "#rfx_file! with keyword list" do
    test "changeset length" do
      file = Tst.gen_file(@base_source)
      changeset = IoInspectDelete.cl_file(file)
      assert [_single_item] = changeset
    end
  end

end
