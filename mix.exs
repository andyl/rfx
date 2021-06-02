defmodule Rfx.MixProject do
  use Mix.Project

  def project do
    [
      app: :rfx,
      version: "0.0.1",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/andyl/rfx",
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      app: nil,
      strip_beams: true
    ]
  end

  defp deps do
    [
      {:sourceror, github: "doorgan/sourceror"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:mix_test_interactive, "~> 1.0", only: :dev, runtime: false},
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md", 
        "guides/introduction.md",
        "guides/refactoring_and_lsp.md",
        "guides/related_tools.md"
      ]
    ]
  end
end
