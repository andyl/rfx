defmodule Mix.Tasks.Rfx.Hello do
  use Mix.Task

  @shortdoc "A test task HELLO"

  @moduledoc """
  A Test Task HELLO.
  """

  def run(_) do
    IO.puts("HELLO HELLO")
  end
end
