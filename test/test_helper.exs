defmodule Tst do

  @base_dir "/tmp/rfx_test_files"

  def base_dir do
    @base_dir
  end

  def gen_file(content) do
    base_dir() |> File.mkdir()
    fname = rand_fn()
    File.write(fname, content)
    fname
  end

  def gen_proj(cmd) do
    base_dir() |> File.mkdir()
    base_dir() |> File.cd()
    [cmd | args] = String.split(cmd, " ")
    dname = rand_dn() 
    System.cmd(cmd, args + [dname])
    dname
  end

  def rand_str(length \\ 4) do
    Stream.repeatedly(&rchar/0) |> Enum.take(length) |> Enum.join()
  end

  defp rand_fn do
    base_dir() <> "/" <> rand_str() <> ".ex"
  end

  defp rand_dn do
    base_dir() <> "/" <> rand_str()
  end

  defp rchar do
    ?a..?z |>
    Enum.to_list() |>
    to_string() |>
    String.split("", trim: true) |>
    Enum.random()
  end

end

File.rm_rf(Tst.base_dir())

ExUnit.start()

