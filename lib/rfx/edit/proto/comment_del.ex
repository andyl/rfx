defmodule Rfx.Edit.Proto.CommentDel do
  @moduledoc """
  Prototype `Rfx.Edit` module - removes comment lines.

  This module is intended for use in functional and integration tests.
  """

  @behaviour Rfx.Edit

  @doc """
  Removes comment line from the source code.

  Example:

      iex> original = """
      ...> # TestComment
      ...> Original Code
      ...> """ |> String.trim()
      ...> expected = "Original Code"
      ...> Rfx.Edit.Proto.CommentDel.edit(original)
      expected

  Note this function will remove any lines that begin with `# TestComment`,
  regardless of whether they contain a label or not.
  """
  @impl true
  def edit(input_source) do
    input_source 
    |> String.split("\n")
    |> Enum.reject(&(Regex.match?(~r/^# TestComment/, &1)))
    |> Enum.join("\n")
  end

  @doc """
  Removes comment line with label from the source code.

  Example:

      iex> original = """
      ...> # TestComment (MyLabel)
      ...> Original Code
      ...> """ |> String.trim()
      ...> expected = "Original Code"
      ...> Rfx.Edit.Proto.CommentDel.edit(original, label: "MyLabel")
      expected
  
  """
  @impl true
  def edit(input_source, label: input_label) do
    input_source 
    |> String.split("\n")
    |> Enum.reject(&(&1 == "# TestComment (#{input_label})"))
    |> Enum.join("\n")
  end
end
