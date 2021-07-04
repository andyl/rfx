defmodule Rfx.Ops.Credo.MultiAlias do

  @behaviour Rfx.Ops

  @moduledoc """
  Refactoring Operations to automatically apply the Credo `multi-alias`
  recommendation.

  Walks the source code and expands instances of multi-alias syntax.

  ## Examples

  Basic transformation...

       iex> source = "alias Foo.{Bar, Baz.Qux}"
       ...>
       ...> expected = """
       ...> alias Foo.Bar
       ...> alias Foo.Baz.Qux
       ...> """ |> String.trim()
       ...>
       ...> Rfx.Ops.Credo.MultiAlias.edit(source)
       expected

  Preserving comments...

       iex> source = """
       ...> # Multi alias example
       ...> alias Foo.{ # Opening the multi alias
       ...>   Bar, # Here is Bar
       ...>   # Here come the Baz
       ...>   Baz.Qux # With a Qux!
       ...> }
       ...> """ |> String.trim()
       ...>
       ...> expected = """
       ...> # Multi alias example
       ...> # Opening the multi alias
       ...> # Here is Bar
       ...> alias Foo.Bar
       ...> # Here come the Baz
       ...> # With a Qux!
       ...> alias Foo.Baz.Qux
       ...> """ |> String.trim()
       ...>
       ...> Rfx.Ops.Credo.MultiAlias.edit(source)
       expected

  """

  alias Rfx.Util.Source
  alias Rfx.Change.Request

  # ----- Propspec -----

  @impl true
  def propspec do
    [
      key: :credo_multi_alias,
      name: "credo.multi_alias",
      about: "Apply multi_alias transformation",
      status: :experimental
    ] 
  end

  # ----- Changesets -----

  @impl true
  def cl_code(old_source, _args \\ []) do
    new_source = edit(old_source)
    {:ok, result} = case Source.diff(old_source, new_source) do
      "" -> {:ok, nil}
      nil -> {:ok, nil}
      diff -> Request.new(text_req: [input_text: old_source, diff: diff])
    end
    [result] |> Enum.reject(&is_nil/1)
  end

  @impl true
  def cl_file(input_file, _args \\ []) do
    old_source = File.read!(input_file)
    new_source = edit(old_source)
    {:ok, result} = case Source.diff(old_source, new_source) do
      "" -> {:ok, nil}
      nil -> {:ok, nil}
      diff -> Request.new(text_req: [input_file: input_file, diff: diff])
    end
    [result] |> Enum.reject(&is_nil/1)
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
  def cl_tmpfile(input_file, _args \\ []) do
    input_file 
    |> cl_file()
  end


  # ----- Edit -----
  
  @impl true
  defdelegate edit(source_code), to: Rfx.Edit.Credo.MultiAlias1

end
