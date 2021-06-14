defmodule Tst do

  @base_dir "/tmp/rfx_test_files"

  alias Rfx.Util.Str

  def base_dir do
    @base_dir
  end

  def gen_file(content) do
    base_dir() |> File.mkdir()
    fname = rand_fn()
    File.write(fname, content)
    fname
  end

  def gen_dir do
    base_dir() |> File.mkdir()
    dname = rand_dn()
    File.mkdir(dname)
    dname
  end

  def gen_proj(cmd) do
    base_dir() |> File.mkdir()
    base_dir() |> File.cd()
    [cmd | args] = String.split(cmd, " ")
    dname = Str.rand_str()
    System.cmd(cmd, args ++ [dname])
    base_dir() <> "/" <> dname
  end

  def rand_fn do
    base_dir() <> "/" <> Str.rand_str() <> ".ex"
  end

  def rand_dn do
    base_dir() <> "/" <> Str.rand_str()
  end

end

File.rm_rf(Tst.base_dir())

ExUnit.start()

