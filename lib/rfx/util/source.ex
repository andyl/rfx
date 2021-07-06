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
    |> Enum.map(&convert_to_map/1)
  end

  @doc """
  Returns modified source, given old source text, and a diff text.
  """
  def patch(source, diff) do
    my_diff = diff |> convert_from_list_of_maps
    Diff.patch(source, my_diff)
    |> Enum.join
  end

  def convert_to_map(diff) do
    diff_as_struct = if is_list(diff) do
      hd diff
    else
      diff
    end

    build_map(diff_as_struct)
  end

  def build_map(diff_as_struct = %Diff.Insert{}) do
    diff_as_struct
    |> Map.from_struct()
    |> Map.put(:type, "Diff.Insert")
    |> map_keys_to_atoms()
  end

  def build_map(diff_as_struct = %Diff.Delete{}) do
    diff_as_struct
    |> Map.from_struct()
    |> Map.put(:type, "Diff.Delete")
    |> map_keys_to_atoms()
  end

  def convert_from_list_of_maps(list_of_maps) do
    Enum.map(list_of_maps, &convert_from_map/1)
  end

  def convert_from_map(%{"type" => "Diff.Insert"} = map) do
    new_map = Map.delete(map, "type")
    struct(%Diff.Insert{}, map_keys_to_atoms(new_map))
  end

  def convert_from_map(%{"type" => "Diff.Delete"} = map) do
    new_map = Map.delete(map, "type")
    struct(%Diff.Delete{}, map_keys_to_atoms(new_map))
  end

  def new_key(key) when is_binary(key), do: String.to_atom(key)
  def new_key(key), do: key

  defp map_keys_to_atoms(map) do
    for {key, val} <- map, into: %{} do
      my_new_key = new_key(key)
      {my_new_key, val}
    end
  end

end
