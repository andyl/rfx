defmodule Rfx.Util.Filesys do
  @moduledoc """
  A utility module for file system operations.
  """
  
  def project_files(root \\ ".") do
    ls_r(root)
    |> Enum.map(&filter/1)
    |> Enum.reject(&is_nil/1)
  end

  def subapp_files(root \\ ".") do
    ls_r(root)
    |> Enum.map(&filter/1)
    |> Enum.reject(&is_nil/1)
  end

  defp ls_r(path) do
    cond do
      File.regular?(path) -> [path]
      File.dir?(path) ->
        File.ls!(path)
        |> Enum.map(&Path.join(path, &1))
        |> Enum.map(&ls_r/1)
        |> Enum.concat
      true -> []
    end
  end

  defp filter(path) do
    cond do
      String.contains?(path, ".git") -> nil
      String.match?(path, ~r/\.ex$/) -> path
      String.match?(path, ~r/\.exs$/) -> path
      true -> nil
    end
  end
end
