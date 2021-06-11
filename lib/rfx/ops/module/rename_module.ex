defmodule Rfx.Ops.Module.RenameModule do

  # TODO: test text editing
  # TODO: add file renaming

  @behaviour Rfx.Ops

  @moduledoc """
  Rename a module.

  Walks the source code and expands instances of multi-alias syntax.

  ## Examples

  Basic transformation...

       iex> source = """
       ...> defmodule MyApp.Test1 do
       ...> end
       ...> """
       ...>
       ...> expected = """
       ...> defmodule MyApp.Test2 do
       ...> end
       ...> """ |> String.trim()
       ...>
       ...> opts = [old_name: "MyApp.Test1", new_name: "MyApp.Test2"]
       ...> Rfx.Ops.Module.RenameModule.edit(source, opts)
       expected

  """

  alias Rfx.Util.Source
  alias Rfx.Change.Req

  # ----- Changelists -----

  @doc """
  ClCode
  """

  @impl true
  def cl_code(file_path: file_path, old_name: old_name, new_name: new_name) do
    old_source = File.read!(file_path)
    new_source = edit(old_source, old_name: old_name, new_name: new_name)
    {:ok, result} = case Source.diff(old_source, new_source) do
      "" -> {:ok, nil}
      nil -> {:ok, nil}
      diff -> Req.new(edit: [file_path: file_path, diff: diff]) 
    end
    [result] |> Enum.reject(&is_nil/1)
  end

  @impl true
  def cl_code(source_code: old_source, old_name: old_name, new_name: new_name) do
    new_source = edit(old_source, old_name: old_name, new_name: new_name)
    {:ok, result} = case Source.diff(old_source, new_source) do
      "" -> {:ok, nil}
      nil -> {:ok, nil}
      diff -> Req.new(edit: [edit_source: old_source, diff: diff])
    end
    [result] |> Enum.reject(&is_nil/1)
  end

  @doc """
  ClFile
  """

  @impl true
  def cl_file(file_path: file_path) do
    cl_code(file_path: file_path)
  end

  @impl true
  def cl_file(file_path) do
    cl_code(file_path: file_path)
  end

  @doc """
  ClProject
  """

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

  @doc """
  ClSubapp
  """

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
  defdelegate edit(source_code, opts), to: Rfx.Edit.Module.RenameModule

end
