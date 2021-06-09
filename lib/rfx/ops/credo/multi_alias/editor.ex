defmodule Rfx.Ops.Credo.MultiAlias.Editor do

  alias Rfx.Source
  
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
