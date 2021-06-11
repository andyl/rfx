defmodule Rfx.Change.Req.Text do

  @moduledoc """
  Change.Req.Text struct and support functions.

  Edit elements - source file and diff.

  Change.Req.Text must have:
  - either *edit_path* or *edit_source*
  - *diff*

  Not using a struct here for now, in order to use the shorthand access syntax
  `edit[:diff]`.
  """

  # ----- Construction -----
  
  def new(file_path: path, diff: diff) do
    valid_struct = %{file_path: path, diff: diff}
    case File.exists?(path) do
      true ->  {:ok, valid_struct}
      _ -> {:error, "No file #{path}"}
    end
  end

  def new(edit_source: source, diff: diff) do
    valid_struct = %{edit_source: source, diff: diff}
    {:ok, valid_struct}
  end

  # ----- Conversion -----

  # ----- Application -----

  def apply! do
  end

end
