defmodule Rfx.Change.Req.FilesysTest do
  use ExUnit.Case

  alias Rfx.Change.Req.Filesys

  # ----- Construction -----

  describe "file_create constructor" do
    test "returns :ok" do
      path = Tst.gen_file("content ok")
      assert {:ok, result} = Filesys.new(cmd: :file_create, src_path: path)
      assert result == %{cmd: :file_create, src_path: path}
    end
  end

  describe "file_move constructor" do
    test "returns :ok" do
      path1 = Tst.gen_file("content 1")
      path2 = Tst.gen_file("content 2")
      assert {:ok, result} = Filesys.new(cmd: :file_move, src_path: path1, tgt_path: path2)
      assert result == %{cmd: :file_move, src_path: path1, tgt_path: path2}
    end
  end

  describe "file_delete constructor" do
    test "returns :ok" do
      path = Tst.gen_file("content ok")
      assert {:ok, result} = Filesys.new(cmd: :file_delete, src_path: path)
      assert result == %{cmd: :file_delete, src_path: path}
    end
  end

  describe "dir_move constructor" do
    test "returns :ok" do
      path1 = Tst.gen_dir()
      path2 = Tst.gen_dir()
      assert {:ok, result} = Filesys.new(cmd: :dir_move, src_path: path1, tgt_path: path2)
      assert result == %{cmd: :dir_move, src_path: path1, tgt_path: path2}
    end
  end

  describe "dir_create constructor" do
    test "returns :ok" do
      path = Tst.gen_dir()
      assert {:ok, result} = Filesys.new(cmd: :dir_create, src_path: path)
      assert result == %{cmd: :dir_create, src_path: path}
    end
  end

  describe "dir_delete constructor" do
    test "returns :ok" do
      path = Tst.gen_dir()
      assert {:ok, result} = Filesys.new(cmd: :dir_delete, src_path: path)
      assert result == %{cmd: :dir_delete, src_path: path}
    end
  end

  # ----- Conversion -----
  
  # ----- Application -----

end
