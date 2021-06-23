defmodule Rfx.Change.Request.FileReqTest do
  use ExUnit.Case

  alias Rfx.Change.Request.FileReq
  alias Rfx.Util.Tst

  # ----- Construction -----

  describe "file_create constructor" do
    test "returns :ok" do
      path = Tst.gen_file("content ok")
      assert {:ok, result} = FileReq.new(cmd: :file_create, src_path: path)
      assert result == %{cmd: :file_create, src_path: path}
    end
  end

  describe "file_move constructor" do
    test "returns :ok" do
      path1 = Tst.gen_file("content 1")
      path2 = Tst.gen_file("content 2")
      assert {:ok, result} = FileReq.new(cmd: :file_move, src_path: path1, tgt_path: path2)
      assert result == %{cmd: :file_move, src_path: path1, tgt_path: path2}
    end
  end

  describe "file_delete constructor" do
    test "returns :ok" do
      path = Tst.gen_file("content ok")
      assert {:ok, result} = FileReq.new(cmd: :file_delete, src_path: path)
      assert result == %{cmd: :file_delete, src_path: path}
    end
  end

  describe "dir_move constructor" do
    test "returns :ok" do
      path1 = Tst.gen_dir()
      path2 = Tst.gen_dir()
      assert {:ok, result} = FileReq.new(cmd: :dir_move, src_path: path1, tgt_path: path2)
      assert result == %{cmd: :dir_move, src_path: path1, tgt_path: path2}
    end
  end

  describe "dir_create constructor" do
    test "returns :ok" do
      path = Tst.gen_dir()
      assert {:ok, result} = FileReq.new(cmd: :dir_create, src_path: path)
      assert result == %{cmd: :dir_create, src_path: path}
    end
  end

  describe "dir_delete constructor" do
    test "returns :ok" do
      path = Tst.gen_dir()
      assert {:ok, result} = FileReq.new(cmd: :dir_delete, src_path: path)
      assert result == %{cmd: :dir_delete, src_path: path}
    end
  end

  # ----- Conversion -----
  
  # ----- Application -----

  describe ":file_create" do
    test "create a file" do
      path = Tst.rand_fn()
      refute File.exists?(path)
      result = %{cmd: :file_create, src_path: path} |> FileReq.apply!() 
      assert File.exists?(path)
      assert result == :ok
    end
  end

  describe ":file_move" do
    test "move a file" do
      path1 = Tst.gen_file("ok")
      path2 = Tst.rand_fn()
      assert File.exists?(path1)
      refute File.exists?(path2)
      result = %{cmd: :file_move, src_path: path1, tgt_path: path2} |> FileReq.apply!()
      refute File.exists?(path1)
      assert File.exists?(path2)
      assert result == :ok
    end
  end

  describe ":file_delete" do
    test "delete a file" do
      path1 = Tst.gen_file("ok")
      assert File.exists?(path1)
      result = %{cmd: :file_delete, src_path: path1} |> FileReq.apply!()
      refute File.exists?(path1)
      assert result == :ok
    end
  end

  describe ":dir_create" do
    test "create a dir" do
      path = Tst.rand_dn()
      refute File.exists?(path)
      result = %{cmd: :dir_create, src_path: path} |> FileReq.apply!()
      assert File.exists?(path)
      assert result == :ok
    end
  end

  describe ":dir_move" do
    test "move a dir" do
      path1 = Tst.gen_dir()
      path2 = Tst.rand_dn()
      assert File.exists?(path1)
      refute File.exists?(path2)
      result = %{cmd: :dir_move, src_path: path1, tgt_path: path2} |> FileReq.apply!()
      refute File.exists?(path1)
      assert File.exists?(path2)
      assert result == :ok
    end
  end

  describe ":dir_delete" do
    test "delete a dir" do
      path1 = Tst.gen_dir()
      assert File.exists?(path1)
      result = %{cmd: :dir_delete, src_path: path1} |> FileReq.apply!()
      refute File.exists?(path1)
      assert result == :ok
    end
  end

end
