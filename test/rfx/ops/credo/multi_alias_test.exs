defmodule Rfx.Ops.Credo.MultiAliasTest do
  use ExUnit.Case

  alias Rfx.Ops.Credo.MultiAlias
  alias Rfx.Util.Source
  alias Rfx.Util.Tst

  @base_source """
  alias Foo.{Bar, Baz.Qux}
  """

  @base_expected """
  alias Foo.Bar
  alias Foo.Baz.Qux
  """ 

  @base_diff """
  1c1,2
  < alias Foo.{Bar, Baz.Qux}
  ---
  > alias Foo.Bar
  > alias Foo.Baz.Qux
  """ 

  doctest MultiAlias

  describe "#rfx_code" do
    test "expected fields" do
      [changereq | _] = MultiAlias.cl_code(@base_source)
      refute changereq |> Map.get(:file_req)
      assert changereq |> Map.get(:text_req)
      assert changereq |> Map.get(:text_req) |> Map.get(:diff)
      assert changereq |> Map.get(:text_req) |> Map.get(:edit_source)
    end

    test "diff generation" do
      [changereq | _] = MultiAlias.cl_code(@base_source)
      diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
      assert diff == @base_diff
    end

    test "patching" do
      [changereq | _] = MultiAlias.cl_code(@base_source)
      code = Map.get(changereq, :text_req) |> Map.get(:edit_source)
      diff = Map.get(changereq, :text_req) |> Map.get(:diff)
      new_code = Source.patch(code, diff)
      assert new_code == @base_expected
    end

    test "no change required source" do
      changeset = MultiAlias.cl_code(@base_expected) 
      assert changeset == []
    end

  end

  describe "#rfx_file! with source file" do
    test "changeset length" do
      file = Tst.gen_file(@base_source)
      changeset = MultiAlias.cl_file(file)
      assert length(changeset) == 1
    end

    # test "changereq fields" do
    #   file = Tst.gen_file(@base_source)
    #   [changereq| _ ] = MultiAlias.cl_file(file)
    #   refute changereq |> Map.get(:file_req)
    #   assert changereq |> Map.get(:text_req)
    #   assert changereq |> Map.get(:text_req) |> Map.get(:diff)
    #   assert changereq |> Map.get(:text_req) |> Map.get(:file_path)
    # end
    #
    # test "diff generation" do
    #   file = Tst.gen_file(@base_source)
    #   [changereq | _] = MultiAlias.cl_file(file)
    #   diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
    #   assert diff == @base_diff
    # end
    #
    # test "patching" do
    #   file = Tst.gen_file(@base_source)
    #   [changereq | _] = MultiAlias.cl_file(file)
    #   code = Map.get(changereq, :text_req) |> Map.get(:file_path) |> File.read() |> elem(1)
    #   diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
    #   new_code = Source.patch(code, diff)
    #   assert new_code == @base_expected
    # end
  end

  # describe "#rfx_file! with keyword list" do
  #   test "changeset length" do
  #     file = Tst.gen_file(@base_source)
  #     changeset = MultiAlias.cl_file(file_path: file)
  #     assert length(changeset) == 1
  #   end
  # end

  # describe "#rfx_project!" do
  #   test "changeset length" do
  #     root_dir = Tst.gen_proj("mix new")
  #     changeset = MultiAlias.cl_project(root_dir)
  #     assert length(changeset) == 0
  #   end
  #
  #   test "changereq fields" do
  #     file = Tst.gen_file(@base_source)
  #     [changereq| _ ] = MultiAlias.cl_file(file)
  #     refute changereq |> Map.get(:file_req)
  #     assert changereq |> Map.get(:text_req)
  #     assert changereq |> Map.get(:text_req) |> Map.get(:diff)
  #     assert changereq |> Map.get(:text_req) |> Map.get(:file_path)
  #   end
  #
  #   test "diff generation" do
  #     file = Tst.gen_file(@base_source)
  #     [changereq | _] = MultiAlias.cl_file(file)
  #     diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
  #     assert diff == @base_diff
  #   end
  #
  #   test "patching" do
  #     file = Tst.gen_file(@base_source)
  #     [changereq | _] = MultiAlias.cl_file(file)
  #     code = Map.get(changereq, :text_req) |> Map.get(:file_path) |> File.read() |> elem(1)
  #     diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
  #     new_code = Source.patch(code, diff)
  #     assert new_code == @base_expected
  #   end
  # end

  # describe "#rfx_tmpfile" do
  #   test "expected fields for source file" do
  #     file = Tst.gen_file(@base_source)
  #     [changereq | _] = MultiAlias.cl_tmpfile(file)
  #     refute changereq |> Map.get(:file_req)
  #     assert changereq |> Map.get(:text_req)
  #     assert changereq |> Map.get(:text_req) |> Map.get(:diff)
  #     assert changereq |> Map.get(:text_req) |> Map.get(:file_path)
  #   end
  #
  #   test "diff generation" do
  #     file = Tst.gen_file(@base_source)
  #     [changereq | _] = MultiAlias.cl_tmpfile(file_path: file)
  #     diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
  #     assert diff == @base_diff
  #   end
  #
  #   test "patching" do
  #     file = Tst.gen_file(@base_source)
  #     [changereq | _] = MultiAlias.cl_tmpfile(file_path: file)
  #     code = Map.get(changereq, :text_req) |> Map.get(:file_path) |> File.read() |> elem(1)
  #     diff = Map.get(changereq, :text_req) |> Map.get(:diff) 
  #     new_code = Source.patch(code, diff)
  #     assert new_code == @base_expected
  #   end
  #
  #   test "no change required code" do
  #     file = Tst.gen_file(@base_expected)
  #     assert [] == MultiAlias.cl_tmpfile(file_path: file)
  #   end
  #
  #   test "no change required ingested code" do
  #     root = Tst.gen_proj("mix new")
  #     proj = root |> String.split("/") |> Enum.reverse() |> Enum.at(0)
  #     file = root <> "/lib/#{proj}.ex"
  #     {:ok, code} = File.read(file)
  #     assert [] == MultiAlias.cl_tmpfile(code)
  #   end
  #
  #   test "no change required file" do
  #     root_dir = Tst.gen_proj("mix new")
  #     proj = root_dir |> String.split("/") |> Enum.reverse() |> Enum.at(0)
  #     file = root_dir <> "/lib/#{proj}.ex"
  #     changeset = MultiAlias.cl_tmpfile(file_path: file)
  #     assert changeset == []
  #   end
  # end


end
