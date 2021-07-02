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
  alias Rfx.Change.Request

  # ----- Argspec -----

  @impl true
  def propspec do
    [
      about: "Rename Module",
      status: :experimental,
      options: [
        new_name: [
          long: "--new_name",
          value_name: "NEW_NAME",
          help: "New Module Name",
          required: true
        ]
      ]
    ] 
  end

  # ----- Changesets -----

  @impl true
  def cl_code(old_source, args =  [old_name: _, new_name: _]) do
    new_source = edit(old_source, args)
    {:ok, result} = case Source.diff(old_source, new_source) do
      "" -> {:ok, nil}
      nil -> {:ok, nil}
      diff -> Request.new(text_req: [input_text: old_source, diff: diff])
    end
    [result] |> Enum.reject(&is_nil/1)
  end

  @impl true
  def cl_file(input_file, args = [old_name: _, new_name: _]) do
    input_file
    |> cl_code(args)
  end

  @impl true
  def cl_project(project_root, args = [old_name: _, new_name: _]) do
    project_root
    |> Rfx.Util.Filesys.project_files()
    |> Enum.map(&(cl_file(&1, args)))
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
  end

  @impl true
  def cl_subapp(subapp_root, args = [old_name: _, new_name: _]) do
    subapp_root
    |> cl_project(args)
  end

  @impl true
  def cl_tmpfile(input_file, args = [old_name: _, new_name: _]) do
    input_file 
    |> cl_file(args)
  end

  # ----- Edit -----
  
  @impl true
  defdelegate edit(source_code, opts), to: Rfx.Edit.Module.RenameModule

end
