defmodule Rfx.Util.Str do

  @moduledoc false

  def purge(string, regex) do
    Regex.replace(regex, string, "")
  end

  def replace(string, regex, replace_string) do
    Regex.replace(regex, string, replace_string)
  end

  def rand_str(length \\ 4) do
    Stream.repeatedly(&rchar/0) |> Enum.take(length) |> Enum.join()
  end

  defp rchar do
    ?a..?z |>
    Enum.to_list() |>
    to_string() |>
    String.split("", trim: true) |>
    Enum.random()
  end

  def terminate_nl(string) do
    case Regex.match?(~r/\n$/, string) do
      true -> string
      false -> string <> "\n"
    end
  end

end
