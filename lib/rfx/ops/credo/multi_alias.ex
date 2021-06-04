defmodule Rfx.Ops.Credo.MultiAlias do

  @moduledoc """
  Refactoring Operations to automatically apply the Credo `multi-alias`
  recommendation.

  Walks the source code and expands instances of multi-alias syntax.

  ## Examples

  Basic transformation...

       iex> source = "alias Foo.{Bar, Baz.Qux}"
       ...>
       ...> result = """
       ...> alias Foo.Bar
       ...> alias Foo.Baz.Qux
       ...> """ |> String.trim()
       ...>
       ...> Rfx.Ops.Credo.MultiAlias.rfx_code(source)
       result

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
       ...> result = """
       ...> # Here is Bar
       ...> # Multi alias example
       ...> # Opening the multi alias
       ...> alias Foo.Bar
       ...> # Here come the Baz
       ...> # With a Qux!
       ...> alias Foo.Baz.Qux
       ...> """ |> String.trim()
       ...>
       ...> Rfx.Ops.Credo.MultiAlias.rfx_code(source)
       result

  """

  alias Rfx.Source

  def rfx_source(source_code: source) do
    rfx_source(source)
  end

  def rfx_source(file_path: file_path) do
    diff = File.read!(file_path) |> edit() |> gen_diff()
    case diff do
      nil -> nil
      diff -> [file_path: file_path, diff: diff]
    end
  end

  def rfx_source(source) do
    diff = source |> edit() |> Source.diff()
    case diff do
      nil -> nil
      diff -> [source_code: source, diff: diff]
    end
  end

  defp gen_diff(old_src: _old_src, new_src: _new_src) do
    ""
  end

  @doc """
  Applies the `multi_alias` transformation to an Elixir source code file.

  - reads the file
  - applies the `multi_alias` transformation to the source
  - writes the fil~j
  """
  def rfx_file(file_name) do
    new_code = file_name
    |> File.read!()
    # |> rfx_code()

    File.write(file_name, new_code)
  end

  @doc """
  Applies the `multi_alias` transformation to every source file in an Elixir project.

  - walk the project directory, and for each source code file:
    - read the file
    - apply the `multi_alias` transformation to the source
    - write the file
  """
  def rfx_project(_project_root) do
    :ok
  end

  # ----- Edit -----

  defp edit(source_code) do
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
    new_source = Source.edit(source_code, efun)
    {source_code, new_source}
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
