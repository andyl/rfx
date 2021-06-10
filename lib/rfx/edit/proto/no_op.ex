defmodule Rfx.Edit.Proto.NoOp do
  @moduledoc """
  Prototype `Rfx.Edit` module - makes no changes.

  This module is intended for use in functional and integration tests.
  """

  @behaviour Rfx.Edit

  @impl true

  @doc """
  NoOp - makes no change to source code.  

  Returns an unaltered string.

  Example:

      iex> "Original Code" |> Rfx.Edit.Proto.NoOp.edit()
      "Original Code"

  """
  def edit(input_source) do
    input_source
  end

end
