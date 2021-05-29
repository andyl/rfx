defmodule Rfx.MixProject do
  use Mix.Project

  def project do
    [
      app: :rfx,
      version: "0.0.1",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      escript: escript(), 
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

  defp escript do
    [
      main_module: Rfx.Cli.Base
    ]
  end

  defp deps do
    [
      {:sourceror, github: "doorgan/sourceror"}
    ]
  end
end
