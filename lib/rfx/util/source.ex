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
    path1 = @base_diff <> "/src1_" <> Str.rand_str()
    path2 = @base_diff <> "/src2_" <> Str.rand_str()

    File.mkdir(@base_diff)
    File.write(path1, src1)
    File.write(path2, src2)
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
    File.write(dpath, diff |> terminate_nl())
    opts = [spath, dpath, "-s", "-o", "-"]
    {new_src, _} = System.cmd("patch", opts)
    File.rm(spath)
    File.rm(dpath)
    # IO.inspect spath
    # IO.inspect dpath
    # IO.inspect source, label: "SOURCE"
    # IO.inspect diff, label: "DIFF"
    # IO.inspect new_src, label: "ZZZ"
    new_src
  end

  defp terminate_nl(string) do
    case Regex.match?(~r/\n$/, string) do
      true -> string
      false -> string <> "\n"
    end
  end

end
