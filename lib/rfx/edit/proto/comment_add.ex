defmodule Rfx.Edit.Proto.CommentAdd do
  @moduledoc """
  Prototype `Rfx.Edit` module - adds comment - use for testing.

  This module is intended for use in functional and integration tests.
  """

  @behaviour Rfx.Edit

  @doc """
  Prepends a comment line to the source code.

  Example:

      iex> original = "Original Code"
      ...> expected = """
      ...> # TestComment
      ...> Original Code
      ...> """ |> String.trim()
      ...> Rfx.Edit.Proto.CommentAdd.edit(original)
      expected

      iex> original = "Original Code"
      ...> expected = """
      ...> # TestComment (MyLabel)
      ...> Original Code
      ...> """ |> String.trim()
      ...> Rfx.Edit.Proto.CommentAdd.edit(original, label: "MyLabel")
      expected

  Intended for use in functional and integration tests.
  """

  @impl true

  def edit(input_source) do
    "# TestComment\n" <> input_source
  end

  def edit(input_source, label: input_label) do
    "# TestComment (#{input_label})\n" <> input_source
  end
end
