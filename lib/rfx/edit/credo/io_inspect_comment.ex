defmodule Rfx.Edit.Credo.IoInspectComment do

  @moduledoc """
  Comments `IO.inspect` statements.

  Uses a simple regex based editor.
  """

  @behaviour Rfx.Edit

  alias Rfx.Util.Str

  @impl true
  @doc """
  Comments `IO.inspect` statements.

  Uses a simple regex based editor.
  """
  def edit(source) do
    regex = ~r/^( *)(\|> IO.inspect([^\|]*))/
    pattern = "\\1# \\2"
    source
    |> String.split("\n")
    |> Enum.map(&(Str.replace(&1, regex, pattern)))
    |> Enum.join("\n")
  end

end
