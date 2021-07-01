defmodule Rfx.Edit.Credo.IoInspectDelete do

  @moduledoc """
  Deletes `IO.inspect` statements.

  Uses a simple regex based editor.
  """

  @behaviour Rfx.Edit

  alias Rfx.Util.Str

  @impl true
  @doc """
  Deletes `IO.inspect` statements.

  Uses a simple regex based editor.
  """
  def edit(source) do
    source
    |> Str.purge(~r/\|> IO.inspect([^\|]*)/)
    |> Str.purge(~r/\IO.inspect([^\|]*)/)
  end

end
