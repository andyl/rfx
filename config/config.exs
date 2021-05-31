use Mix.Config

if Mix.env == :dev do
  config :mix_test_interactive, clear: true
end
