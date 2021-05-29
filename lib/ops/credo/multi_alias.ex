defmodule Rfx.Ops.Credo.MultiAlias do

  @moduledoc """
  Refactoring Operations to automatically fix the Credo 'multi-alias'
  recommendations.

  Walks the source code and expands instances of multi alias syntax like
  ```elixir
  alias Foo.{Bar, Baz.Qux}
  ```
  to individual aliases:
  ```elixir
  alias Foo.Bar
  alias Foo.Baz.Qux
  ```

  It also preserves the comments:
  ```elixir
  # Multi alias example
  alias Foo.{ # Opening the multi alias
    Bar, # Here is Bar
    # Here come the Baz
    Baz.Qux # With a Qux!
  }
  ```

  ```elixir
  # Multi alias example
  # Opening the multi alias
  # Here is Bar
  alias Foo.Bar
  # Here come the Baz
  # With a Qux!
  alias Foo.Baz.Qux
  ```
  """

  @doc """
  Applies the Multi-Alias transformation to a block of Elixir source code.
  """
  def rfx_source(source_code) do
    source_code
    |> Sourceror.parse_string()
    |> Sourceror.postwalk(fn
      {:alias, _, [{{:., _, [_, :{}]}, _, _}]} = quoted, state ->
        {aliases, line_correction} = expand_alias(quoted, state.line_correction)
        state = %{state | line_correction: line_correction}
        {{:__block__, [flatten_me?: true], aliases}, state}

      {:__block__, meta, args}, state ->
        args = flatten_aliases_blocks(args)

        {{:__block__, meta, args}, state}

      quoted, state ->
        {quoted, state}
    end)
    |> Sourceror.to_string()
  end

  @doc """
  Applies the `multi_alias` transformation to an Elixir source code file.

  - reads the file
  - applies the `multi_alias` transformation to the source
  - writes the file
  """
  def rfx_file!(_file_name) do
    :ok
  end

  @doc """
  Applies the `multi_alias` transformation to every source file in an Elixir project.

  - walk the project directory, and for each source code file:
    - read the file
    - apply the `multi_alias` transformation to the source
    - write the file
  """
  def rfx_project!(_project_root) do
    :ok
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
