defmodule Rfx.Ops.Proto.CommentDel do

  @behaviour Rfx.Ops

  @moduledoc """
  Walks the source code and deletes comment lines.

  Matches comments with this format:

      # TestComment
      # TestComment (<mylabel>)

  This is a prototype operation used for demos and integration testing.

  """

  alias Rfx.Util.Source
  alias Rfx.Change.Req

  # ----- Argspec -----

  @impl true
  def argspec do
    []
  end

  # ----- Changesets -----

  @impl true
  def cl_code(old_source, _args \\ []) do
    new_source = edit(old_source)
    {:ok, result} = case Source.diff(old_source, new_source) do
      "" -> {:ok, nil}
      nil -> {:ok, nil}
      diff -> Req.new(text_req: [edit_source: old_source, diff: diff])
    end
    [result] |> Enum.reject(&is_nil/1)
  end

  @impl true
  def cl_file(file_path, _args \\ []) do
    file_path
    |> cl_code()
  end

  @impl true
  def cl_project(project_root, _args \\ []) do
    project_root
    |> Rfx.Util.Filesys.project_files()
    |> Enum.map(&cl_file/1)
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
  end

  @impl true
  def cl_subapp(subapp_root, _args \\ []) do
    subapp_root
    |> cl_project()
  end

  @impl true
  def cl_tmpfile(file_path, _args \\ []) do
    file_path 
    |> cl_file()
  end

  # ----- Edit -----
  
  @impl true
  defdelegate edit(source_code), to: Rfx.Edit.Proto.CommentDel
  @impl true
  defdelegate edit(source_code, opts), to: Rfx.Edit.Proto.CommentDel

end
