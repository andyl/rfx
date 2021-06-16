defmodule Rfx.Ops.Proto.NoOpTest do
  use ExUnit.Case

  alias Rfx.Ops.Proto.NoOp

  @base_source """
  InputSource
  """

  doctest NoOp

  describe "#cl_code" do
    test "changelist length" do
      assert [] = NoOp.cl_code(@base_source)
    end

    test "expected fields" do
      assert [] = NoOp.cl_code(@base_source)
    end

    test "diff generation" do
      assert [] = NoOp.cl_code(@base_source)
    end

    test "patching" do
      assert [] = NoOp.cl_code(@base_source)
    end
  end

  describe "#cl_code with source file" do
    test "changelist length" do
      file = Tst.gen_file(@base_source)
      assert [] = NoOp.cl_file(file)
    end

    test "expected fields for source file" do
      file = Tst.gen_file(@base_source)
      assert [] = NoOp.cl_code(file_path: file)
    end

    test "diff generation" do
      file = Tst.gen_file(@base_source)
      assert [] = NoOp.cl_code(file_path: file)
    end

    test "patching" do
      file = Tst.gen_file(@base_source)
      assert [] = NoOp.cl_code(file_path: file)
    end
  end

  describe "#cl_file with source file" do
    test "changelist length" do
      file = Tst.gen_file(@base_source)
      assert [] = NoOp.cl_file(file)
    end

    test "changereq fields" do
      file = Tst.gen_file(@base_source)
      assert [] = NoOp.cl_file(file)
    end

    test "diff generation" do
      file = Tst.gen_file(@base_source)
      assert [] = NoOp.cl_file(file)
    end

    test "patching" do
      file = Tst.gen_file(@base_source)
      assert [] = NoOp.cl_file(file)
    end
  end

  describe "#cl_file with keyword list" do
    test "changelist length" do
      file = Tst.gen_file(@base_source)
      assert [] = NoOp.cl_file(file)
    end
  end

  describe "#cl_project!" do
    test "changelist length" do
      root_dir = Tst.gen_proj("mix new")
      assert [] = NoOp.cl_project(root_dir)
    end
  end
end
