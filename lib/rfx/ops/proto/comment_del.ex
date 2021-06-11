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

  # ----- Changelists -----

  @impl true
  def cl_code(source_code: source) do
    cl_code(source)
  end

  @impl true
  def cl_code(file_path: file_path) do
    old_source = File.read!(file_path)
    new_source = edit(old_source)
    {:ok, result} = case Source.diff(old_source, new_source) do
      "" -> {:ok, nil}
      nil -> {:ok, nil}
      diff -> Req.new(edit: [file_path: file_path, diff: diff]) 
    end
    [result] |> Enum.reject(&is_nil/1)
  end

  @impl true
  def cl_code(old_source) do
    new_source = edit(old_source)
    {:ok, result} = case Source.diff(old_source, new_source) do
      "" -> {:ok, nil}
      nil -> {:ok, nil}
      diff -> Req.new(edit: [edit_source: old_source, diff: diff])
    end
    [result] |> Enum.reject(&is_nil/1)
  end

  @impl true
  def cl_file(file_path: file_path) do
    cl_code(file_path: file_path)
  end

  @impl true
  def cl_file(file_path) do
    cl_code(file_path: file_path)
  end

  @impl true
  def cl_project(project_root: project_root) do
    project_root
    |> Rfx.Util.Filesys.project_files()
    |> Enum.map(&cl_file/1)
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
  end

  @impl true
  def cl_project(project_root) do
    cl_project(project_root: project_root)
  end

  @impl true
  def cl_subapp(subapp_root: subapp_root) do
    subapp_root
    |> Rfx.Util.Filesys.subapp_files()
    |> Enum.map(&cl_file/1)
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
  end

  @impl true
  def cl_subapp(subapp_root) do
    cl_subapp(subapp_root: subapp_root)
  end

  # ----- Edit -----
  
  @impl true
  defdelegate edit(source_code), to: Rfx.Edit.Proto.CommentDel
  @impl true
  defdelegate edit(source_code, opts), to: Rfx.Edit.Proto.CommentDel

end
