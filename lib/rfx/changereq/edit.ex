defmodule Rfx.Changereq.Edit do

  @moduledoc """
  Changereq.Edit struct and support functions.

  Edit elements - source file and diff.

  Changereq.Edit must have:
  - either *edit_path* or *edit_source*
  - *diff*
  """
  
  @enforce_keys [:diff]

  defstruct [:edit_file, :edit_source, :diff]

  alias Rfx.Changereq.Edit

  # ----- Construction -----
  
  def new(edit_file: path, diff: diff) do
    valid_struct = %Edit{edit_file: path, diff: diff}
    case File.exists?(path) do
      true ->  {:ok, valid_struct}
      _ -> {:error, "No file #{path}"}
    end
  end

  def new(edit_source: source, diff: diff) do
    valid_struct = %Edit{edit_source: source, diff: diff}
    {:ok, valid_struct}
  end

  # ----- Conversion -----

  # ----- Application -----

  def apply! do
  end

end
