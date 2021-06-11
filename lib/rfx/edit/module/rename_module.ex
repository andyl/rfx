defmodule Rfx.Edit.Module.RenameModule do
  @moduledoc """
  Rename module.
  """

  @behaviour Rfx.Edit

  @impl true

  @doc """
  Rename Module
  """
  def edit(input_source, old_name: old_name, new_name: new_name) do
    input_source
    |> String.replace(old_name, new_name)
  end
end
