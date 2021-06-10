defmodule Rfx.Edit.Proto.CommentAdd do
  @moduledoc """
  Prototype `Rfx.Edit` module - adds comment line.

  This module is intended for use in functional and integration tests.
  """

  @behaviour Rfx.Edit

  @impl true

  @doc """
  Prepends a comment line.

  Example:

      iex> original = "Original Code"
      ...> expected = """
      ...> # TestComment
      ...> Original Code
      ...> """ |> String.trim()
      ...> Rfx.Edit.Proto.CommentAdd.edit(original)
      expected

  """
  def edit(input_source) do
    "# TestComment\n" <> input_source
  end

  @doc """
  Prepends a comment line with a label.  

  Example:

      iex> original = "Original Code"
      ...> expected = """
      ...> # TestComment (MyLabel)
      ...> Original Code
      ...> """ |> String.trim()
      ...> Rfx.Edit.Proto.CommentAdd.edit(original, label: "MyLabel")
      expected

  """
  def edit(input_source, label: input_label) do
    "# TestComment (#{input_label})\n" <> input_source
  end
end
