defmodule Mix.Tasks.Deps.Add do
  use Mix.Task

  @user_agent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36'

  @impl Mix.Task
  def run([name, version | _] = _args) do
    add_dep(name, version)
  end

  def run([name | _] = _args) do
    :inets.start()
    :ssl.start()

    url = 'https://hex.pm/api/packages/' ++ String.to_charlist(name)

    with {:ok, response} <- :httpc.request(:get, {url, [{'User-Agent', @user_agent}]}, [], []) do
      {_, _, body} = response

      version =
        body
        |> List.to_string()
        |> Jason.decode!()
        |> Map.get("latest_stable_version")

      %{major: major, minor: minor} = Version.parse!(version)

      version = "#{major}.#{minor}"

      add_dep(name, version)
    end
  end

  defp add_dep(name, version) do
    source = File.read!("mix.exs")

    new_source =
      source
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

    File.write!("mix.exs", new_source)
  end
end
