defmodule Rfx.Edit.Proto.NoOp do
  @moduledoc """
  Prototype `Rfx.Edit` module - makes no changes - use for testing.

  Returns an unaltered string.

  Example:

      iex> "Original Code" |> Rfx.Edit.Proto.NoOp.edit()
      "Original Code"

  This module is intended for use in functional and integration tests.
  """

  @behaviour Rfx.Edit

  @doc """
  NoOp - makes no change to source code.  

  Intended for use in functional and integration tests.
  """

  @impl true
  def edit(input_source) do
    input_source
  end

end
