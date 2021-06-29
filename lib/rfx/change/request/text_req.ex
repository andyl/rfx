defmodule Rfx.Change.Request.TextReq do

  @moduledoc """
  Change.Req.Text struct and support functions.

  Edit elements - source file and diff.

  Change.Req.Text must have:
  - either *edit_path* or *input_text*
  - *diff*

  Not using a struct here for now, in order to use the shorthand access syntax
  `edit[:diff]`.
  """

  alias Rfx.Util.Source

  # ----- Construction -----

  def new(input_file: path, diff: diff) do
    valid_struct = %{input_file: path, diff: diff}
    case File.exists?(path) do
      true ->  {:ok, valid_struct}
      _ -> %{error: "No file #{path}"}
    end
  end

  def new(input_text: source, diff: diff) do
    valid_struct = %{input_text: source, diff: diff}
    {:ok, valid_struct}
  end

  # ----- Application -----
  
  def apply!(%{input_file: path, diff: diff}) do
    new_source = path
                 |> File.read!()
                 |> Source.patch(diff)
    File.write(path, new_source)
    {:ok, "File #{path} updated with new content"}
  end

  def apply!(%{input_text: _source, diff: _}) do
    %{error: "Can only apply changes to a file."}
  end

  # ----- Conversion -----

  def to_string(%{input_file: path, diff: diff}) do
    path 
    |> File.read!()
    |> Source.patch(diff)
  end

  def to_string(%{input_text: source, diff: diff}) do
    source 
    |> Source.patch(diff)
  end

end
