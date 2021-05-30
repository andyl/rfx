defmodule Rfx.Cli.Base do

  # rfx --help
  # rfx help
  # rfx project.deps_add --dependency <dep> --version <vsn> 
  # rfx project.version
  # rfx module.rename
  # rfx module.rename_attribute
  # rfx module.extract_function
  # rfx module.inline_function
  # rfx function.rename
  # rfx function.rename_parameter
  # rfx function.rename_variable
  # rfx function.extract_variable
  # rfx function.inline_variable
  # rfx credo.multi_alias
  #
  # TODO:
  # - [ ] call Refactoring Operations
  # - [ ] pull subcommands into separate modules
  # - [ ] spec arguments for each subcommand
  # - [ ] detect and handle STDIN 

  defp get_stdin do
    case IO.read(:stdio, :line) do
      :eof -> ""
      {:error, _} -> ""
      data -> data
    end
  end

  def main(argv) do
    input = get_stdin()
    IO.puts "INPUT START"
    IO.puts input
    IO.puts "INPUT FINISH"
    Optimus.new!(
      name: "rfx",
      description: "Refactoring operations for Elixir",
      version: "0.0.1",
      author: "Andy Leak andy@r210.com",
      about: "A collection of refactoring operations for Elixir Code.",
      allow_unknown_args: false,
      parse_double_dash: true,
      args: [
        project_dir: [
          value_name: "PROJECT_FILE",
          help: "Root directory of your Elixir project",
          required: false,
          parser: :string
        ],
        source_file: [
          value_name: "SOURCE_FILE",
          help: "File containing source code",
          required: false,
          parser: :string
        ]
      ],
      flags: [
        verbosity: [
          short: "-v",
          help: "Verbosity level",
          multiple: true,
        ],
      ],
      subcommands: [
        project_test: [
          name: "project.test",
          about: "Refactoring Operations for Projects",
          args: [
            file: [
              value_name: "FILE",
              help: "File with raw data to validate",
              required: true,
              parser: :string
            ]
          ]
        ]
      ]
    ) |> Optimus.parse!(argv) |> IO.inspect
  end
end
