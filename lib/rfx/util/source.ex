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
    String.myers_difference(src1, src2)
    |> convert_keyword_list_to_nested_list()
  end

  @doc """
  Returns modified source, given old source text, and a diff text.
  """
  #TODO: remove patch/2 since diff contains all info needed.
  def patch(_source, diff), do: patch(diff)
  def patch(diff) do
    Enum.reduce diff, "", fn(nested_list, acc) ->
      process(nested_list, acc)
    end
  end

  defp convert_keyword_list_to_nested_list(list) do
    Enum.into(list, [], fn tuple ->
      {k, v} = tuple
      [k, v]
    end)
  end

  defp process(["eq", value], acc), do: acc <> value
  defp process(["ins", value], acc), do: acc <> value
  defp process(x, acc) when is_atom(x), do: process(Atom.to_string(x), acc)
  defp process(_, acc), do: acc
end
