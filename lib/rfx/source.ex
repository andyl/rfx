defmodule Rfx.Source do
  @moduledoc """
  A utility module for source code manipulation.
  """

  def edit(code, efun) do
    code
    |> Sourceror.parse_string()
    |> Sourceror.postwalk(efun)
    |> Sourceror.to_string()
  end

  def diff(old_source, new_source), do: diff({old_source, new_source})

  def diff({src1, src2}) do
    path1 = "/tmp/src1"
    path2 = "/tmp/src2"
    File.write(path1, src1)
    File.write(path2, src2)
    {diff, _} = System.cmd("diff", [path1, path2])
    diff
  end

  def patch(source, diff) do
    spath = "/tmp/source"
    dpath = "/tmp/diff"
    File.write(spath, source)
    File.write(dpath, diff)
    opts = [spath, dpath, "-o", "-", "2>", "/dev/null"]
    {new_src, _} = System.cmd("patch", opts)
    new_src
  end
end
