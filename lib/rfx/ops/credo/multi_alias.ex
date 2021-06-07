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
       ...> # Here is Bar
       ...> # Multi alias example
       ...> # Opening the multi alias
       ...> alias Foo.Bar
       ...> # Here come the Baz
       ...> # With a Qux!
       ...> alias Foo.Baz.Qux
       ...> """ |> String.trim()
       ...>
       ...> Rfx.Ops.Credo.MultiAlias.edit(source)
       expected

  """

  alias Rfx.Source
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


  @doc """
  Applies the `multi_alias` transformation to an Elixir source code file.

  - reads the file
  - applies the `multi_alias` transformation to the source
  - return a changelist
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
  Applies the `multi_alias` transformation to every source file in an Elixir project.

  - walk the project directory, and for each source code file:
  - read the file
  """

  @impl true
  def cl_project(project_root: project_root) do
    project_root
    |> Rfx.Filesys.project_files()
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
    |> Rfx.Filesys.subapp_files()
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
  def edit(source_code) do
    efun = fn
      {:alias, _, [{{:., _, [_, :{}]}, _, _}]} = quoted, state ->
        {aliases, line_correction} = expand_alias(quoted, state.line_correction)
        state = %{state | line_correction: line_correction}
        {{:__block__, [flatten_me?: true], aliases}, state}

      {:__block__, meta, args}, state ->
        args = flatten_aliases_blocks(args)

        {{:__block__, meta, args}, state}

      quoted, state ->
        {quoted, state}
    end
    Source.edit(source_code, efun)
  end

  defp expand_alias({:alias, alias_meta, [{{:., _, [left, :{}]}, _, right}]}, line_correction) do
    alias_meta = Sourceror.correct_lines(alias_meta, line_correction)

    {_, _, base} = left

    aliases =
      right
      |> Enum.with_index()
      |> Enum.map(fn {aliases, index} ->
        {_, meta, segments} = aliases
        line = alias_meta[:line] + index
        meta = Keyword.put(meta, :line, line)

        meta =
          if index == 0 do
            Keyword.update!(meta, :leading_comments, &(&1 ++ alias_meta[:leading_comments]))
          else
            meta
          end

        {:alias, meta, [{:__aliases__, [line: line], base ++ segments}]}
      end)

    newlines = get_in(alias_meta, [:end_of_expression, :newlines]) || 1

    line_correction = line_correction + length(aliases) + newlines

    {aliases, line_correction}
  end

  defp flatten_aliases_blocks(args) do
    Enum.reduce(args, [], fn
      {:__block__, [flatten_me?: true], aliases}, args ->
        args ++ aliases

      quoted, args ->
        args ++ [quoted]
    end)
  end
end
