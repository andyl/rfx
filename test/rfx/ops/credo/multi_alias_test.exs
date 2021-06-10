defmodule Rfx.Ops.Credo.MultiAliasTest do
  use ExUnit.Case

  alias Rfx.Ops.Credo.MultiAlias
  alias Rfx.Util.Source

  @base_source """
  alias Foo.{Bar, Baz.Qux}
  """

  @base_expected """
  alias Foo.Bar
  alias Foo.Baz.Qux
  """ |> String.trim()

  @base_diff """
  1c1,2
  < alias Foo.{Bar, Baz.Qux}
  ---
  > alias Foo.Bar
  > alias Foo.Baz.Qux
  \\ No newline at end of file

  """ |> String.trim()

  doctest MultiAlias

  describe "#rfx_code with source code" do
    @tag :pending
    test "expected fields" do
      [changereq | _] = MultiAlias.cl_code(@base_source)
      refute changereq |> Map.get(:filesys)
      assert changereq |> Map.get(:edit)
      assert changereq |> Map.get(:edit) |> Map.get(:diff)
      assert changereq |> Map.get(:edit) |> Map.get(:edit_source)
    end

    @tag :pending
    test "diff generation" do
      [changereq | _] = MultiAlias.cl_code(@base_source)
      diff = Map.get(changereq, :edit) |> Map.get(:diff) |> String.trim()
      assert diff == @base_diff
    end

    @tag :pending
    test "patching" do
      [changereq | _] = MultiAlias.cl_code(@base_source)
      code = Map.get(changereq, :edit) |> Map.get(:edit_source)
      diff = Map.get(changereq, :edit) |> Map.get(:diff) |> String.trim()
      new_code = Source.patch(code, diff)
      assert new_code == @base_expected
    end

    @tag :pending
    test "no change required source" do
      changelist = MultiAlias.cl_code(@base_expected) 
      assert changelist == []
    end

  end

  describe "#rfx_code with source file" do
    @tag :pending
    test "expected fields for source file" do
      file = Tst.gen_file(@base_source)
      [changereq | _] = MultiAlias.cl_code(file_path: file)
      refute changereq |> Map.get(:filesys)
      assert changereq |> Map.get(:edit)
      assert changereq |> Map.get(:edit) |> Map.get(:diff)
      assert changereq |> Map.get(:edit) |> Map.get(:file_path)
    end

    @tag :pending
    test "diff generation" do
      file = Tst.gen_file(@base_source)
      [changereq | _] = MultiAlias.cl_code(file_path: file)
      diff = Map.get(changereq, :edit) |> Map.get(:diff) |> String.trim()
      assert diff == @base_diff
    end

    @tag :pending
    test "patching" do
      file = Tst.gen_file(@base_source)
      [changereq | _] = MultiAlias.cl_code(file_path: file)
      code = Map.get(changereq, :edit) |> Map.get(:file_path) |> File.read() |> elem(1)
      diff = Map.get(changereq, :edit) |> Map.get(:diff) |> String.trim()
      new_code = Source.patch(code, diff)
      assert new_code == @base_expected
    end

    @tag :pending
    test "no change required code" do
      file = Tst.gen_file(@base_expected)
      assert [] == MultiAlias.cl_code(file_path: file)
    end

    @tag :pending
    test "no change required ingested code" do
      root = Tst.gen_proj("mix new")
      proj = root |> String.split("/") |> Enum.reverse() |> Enum.at(0)
      file = root <> "/lib/#{proj}.ex"
      {:ok, code} = File.read(file)
      [changelist | _] = MultiAlias.cl_code(code)
      changelist |> Map.get(:edit) |> Map.get(:edit_source)
      assert [] == MultiAlias.cl_code(code)
    end

    @tag :pending
    test "no change required file" do
      root_dir = Tst.gen_proj("mix new")
      proj = root_dir |> String.split("/") |> Enum.reverse() |> Enum.at(0)
      file = root_dir <> "/lib/#{proj}.ex"
      changelist = MultiAlias.cl_code(file_path: file)
      assert changelist == []
    end
  end

  describe "#rfx_file! with source file" do
    @tag :pending
    test "changelist length" do
      file = Tst.gen_file(@base_source)
      changelist = MultiAlias.cl_file(file)
      assert length(changelist) == 1
    end

    @tag :pending
    test "changereq fields" do
      file = Tst.gen_file(@base_source)
      [changereq| _ ] = MultiAlias.cl_file(file)
      refute changereq |> Map.get(:filesys)
      assert changereq |> Map.get(:edit)
      assert changereq |> Map.get(:edit) |> Map.get(:diff)
      assert changereq |> Map.get(:edit) |> Map.get(:file_path)
    end

    @tag :pending
    test "diff generation" do
      file = Tst.gen_file(@base_source)
      [changereq | _] = MultiAlias.cl_file(file)
      diff = Map.get(changereq, :edit) |> Map.get(:diff) |> String.trim()
      assert diff == @base_diff
    end

    @tag :pending
    test "patching" do
      file = Tst.gen_file(@base_source)
      [changereq | _] = MultiAlias.cl_file(file)
      code = Map.get(changereq, :edit) |> Map.get(:file_path) |> File.read() |> elem(1)
      diff = Map.get(changereq, :edit) |> Map.get(:diff) |> String.trim()
      new_code = Source.patch(code, diff)
      assert new_code == @base_expected
    end
  end

  describe "#rfx_file! with keyword list" do
    @tag :pending
    test "changelist length" do
      file = Tst.gen_file(@base_source)
      changelist = MultiAlias.cl_file(file_path: file)
      assert length(changelist) == 1
    end
  end

  describe "#rfx_project!" do
    @tag :pending
    test "changelist length" do
      root_dir = Tst.gen_proj("mix new")
      changelist = MultiAlias.cl_project(root_dir)
      assert length(changelist) == 5
    end

    @tag :pending
    test "changereq fields" do
      file = Tst.gen_file(@base_source)
      [changereq| _ ] = MultiAlias.cl_file(file)
      refute changereq |> Map.get(:filesys)
      assert changereq |> Map.get(:edit)
      assert changereq |> Map.get(:edit) |> Map.get(:diff)
      assert changereq |> Map.get(:edit) |> Map.get(:file_path)
    end

    @tag :pending
    test "diff generation" do
      file = Tst.gen_file(@base_source)
      [changereq | _] = MultiAlias.cl_file(file)
      diff = Map.get(changereq, :edit) |> Map.get(:diff) |> String.trim()
      assert diff == @base_diff
    end

    @tag :pending
    test "patching" do
      file = Tst.gen_file(@base_source)
      [changereq | _] = MultiAlias.cl_file(file)
      code = Map.get(changereq, :edit) |> Map.get(:file_path) |> File.read() |> elem(1)
      diff = Map.get(changereq, :edit) |> Map.get(:diff) |> String.trim()
      new_code = Source.patch(code, diff)
      assert new_code == @base_expected
    end
  end

end
