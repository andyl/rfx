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
  # - [x] design how to call Refactoring Operations
  # - [x] design how to detect and handle STDIN 
  # - [x] spec arguments for each subcommand
  # - [-] pull subcommands into separate modules

  # defp get_stdin do
  #   case IO.read(:stdio, :line) do
  #     :eof -> ""
  #     {:error, _} -> ""
  #     data -> data
  #   end
  # end

  def main(argv) do
    Optimus.new!(
      name: "rfx",
      description: "Refactoring operations for Elixir",
      version: "0.0.1",
      author: "Andy Leak andy@r210.com",
      about: "A collection of refactoring operations for Elixir Code.",
      allow_unknown_args: false,
      parse_double_dash: true,
      subcommands: [
        project_alt: [
          name: "project.alt",
          about: "Refactoring Operations for Projects",
          flags: [
            subapp_dir: [
              short: "-s",
              help: "Subapp Directory",
              multiple: false,
            ]
          ],
          args: [
            file: [
              value_name: "FILE",
              help: "File with raw data to validate",
              required: true,
              parser: :string
            ]
          ]
        ], 
        project_test: [
          name: "project.test",
          about: "Refactoring Operations Hey Hey",
          flags: [
            subapp_dir: [
              short: "-s",
              help: "Subapp Directory",
              multiple: false,
            ]
          ],
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
