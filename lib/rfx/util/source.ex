defmodule Rfx.Util.Source do
  @moduledoc """
  A utility module for source code manipulation.
  """

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
    Diff.diff(src1, src2)
  end

  @doc """
  Returns modified source, given old source text, and a diff text.
  """
  def patch(source, diff) do
    Diff.patch(source, diff) |> Enum.join
  end

end
