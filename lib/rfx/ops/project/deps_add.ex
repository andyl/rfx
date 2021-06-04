defmodule Rfx.Ops.Project.DepsAdd do

  def cl_code(source_code, name, version) do
      source_code
      |> Sourceror.parse_string()
      |> Sourceror.postwalk(fn
        {:defp, meta, [{:deps, _, _} = fun, body]}, state ->
          [{{_, _, [:do]}, block_ast}] = body
          {:__block__, block_meta, [deps]} = block_ast

          dep_line =
            case List.last(deps) do
              {_, meta, _} ->
                meta[:line] || block_meta[:line]

              _ ->
                block_meta[:line]
            end + 1

          deps =
            deps ++
              [
                {:__block__, [line: dep_line],
                 [
                   {
                     String.to_atom(name),
                     {:__block__, [line: dep_line, delimiter: "\""], ["~> " <> version]}
                   }
                 ]}
              ]

          ast = {:defp, meta, [fun, [do: {:__block__, block_meta, [deps]}]]}
          state = Map.update!(state, :line_correction, & &1)
          {ast, state}

        other, state ->
          {other, state}
      end)
      |> Sourceror.to_string()
  end

  def cl_file!(file_name, name, version) do
    new_source = file_name
    |> File.read!()
    |> cl_code(name, version)

    File.write(file_name, new_source)
  end

  def cl_project!(project_root, name, version) do
    file_name = project_root <> "mix.exs"
    cl_file!(file_name, name, version)
  end

end
