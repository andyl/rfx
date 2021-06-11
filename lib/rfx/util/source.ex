defmodule Rfx.Util.Source do
  @moduledoc """
  A utility module for source code manipulation.
  """

  alias Rfx.Util.Str

  @base_diff "/tmp/rfx_base_diff"

  @doc """
  Returns updated text, edited according to the Sourceror edit function.
  """
  def edit(code, efun) do
    code
    |> Sourceror.parse_string()
    |> Sourceror.postwalk(efun)
    |> Sourceror.to_string()
  end

  @doc """
  Returns diff text, given two source texts.
  """
  def diff(old_source, new_source), do: diff({old_source, new_source})

  def diff({src1, src2}) do
    rand = Str.rand_str()
    path1 = @base_diff <> "/src1_" <> rand
    path2 = @base_diff <> "/src2_" <> rand

    File.mkdir(@base_diff)
    File.write(path1, src1 |> Str.terminate_nl())
    File.write(path2, src2 |> Str.terminate_nl())
    {diff, _} = System.cmd("diff", [path1, path2])
    File.rm(path1)
    File.rm(path2)
    diff
  end

  @doc """
  Returns modified source, given old source text, and a diff text.
  """
  def patch(source, diff) do
    ext = Str.rand_str()
    spath = @base_diff <> "/patch_src_" <> ext
    dpath = @base_diff <> "/patch_dif_" <> ext

    File.mkdir(@base_diff)
    File.write(spath, source)
    File.write(dpath, diff |> Str.terminate_nl())
    opts = [spath, dpath, "-s", "-o", "-"]
    {new_src, _} = System.cmd("patch", opts)
    File.rm(spath)
    File.rm(dpath)
    new_src
  end

end
