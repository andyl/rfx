defmodule Rfx.Edit.Credo.MultiAlias1 do
  @behaviour Rfx.Edit

  @impl true
  def edit(source) do
    source
    |> Sourceror.parse_string!()
    |> expand_aliases()
    |> Sourceror.to_string()
  end

  defp expand_aliases(quoted) do
    Sourceror.postwalk(quoted, fn
      {:alias, _, [{{:., _, [_, :{}]}, _, _}]} = quoted, state ->
        {aliases, state} = expand_alias(quoted, state)

        {{:__block__, [unwrap_me?: true], aliases}, state}

      {:__block__, meta, args}, state ->
        args = Enum.reduce(args, [], &unwrap_aliases/2)

        {{:__block__, meta, args}, state}

      quoted, state ->
        {quoted, state}
    end)
  end

  defp unwrap_aliases({:__block__, [unwrap_me?: true], aliases}, args) do
    args ++ aliases
  end

  defp unwrap_aliases(quoted, args) do
    args ++ [quoted]
  end

  defp expand_alias({:alias, alias_meta, [{{:., _, [left, :{}]}, call_meta, right}]}, state) do
    {_, _, base_segments} = left

    leading_comments = alias_meta[:leading_comments] || []
    trailing_comments = call_meta[:trailing_comments] || []

    aliases =
      right
      |> Enum.map(&segments_to_alias(base_segments, &1))
      |> put_leading_comments(leading_comments)
      |> put_trailing_comments(trailing_comments)

    {aliases, state}
  end

  defp segments_to_alias(base_segments, {_, meta, segments}) do
    {:alias, meta, [{:__aliases__, [], base_segments ++ segments}]}
  end

  defp put_leading_comments([first | rest], comments) do
    [Sourceror.prepend_comments(first, comments) | rest]
  end

  defp put_trailing_comments(list, comments) do
    case List.pop_at(list, -1) do
      {nil, list} ->
        list

      {last, list} ->
        last =
          {:__block__,
           [
             trailing_comments: comments,
             # End of expression newlines higher than 1 will cause the formatter to add an
             # additional line break after the node. This is entirely optional and only showcased
             # here to improve the readability of the output
             end_of_expression: [newlines: 2]
           ], [last]}

        list ++ [last]
    end
  end
end
