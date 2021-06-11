use Mix.Config

# Clear screen before every test run
if Mix.env == :dev do
  config :mix_test_interactive, clear: true
end
