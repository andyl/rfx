defmodule Examples.Credo.MultiAlias do
  @moduledoc false

  @doc """
  Walks the source code and expands instances of multi alias syntax like
  ```elixir
  alias Foo.{Bar, Baz.Qux}
  ```
  to individual aliases:
  ```elixir
  alias Foo.Bar
  alias Foo.Baz.Qux
  ```

  It also preserves the comments:
  ```elixir
  # Multi alias example
  alias Foo.{ # Opening the multi alias
    Bar, # Here is Bar
    # Here come the Baz
    Baz.Qux # With a Qux!
  }
  ```
  ```elixir
  # Multi alias example
  # Opening the multi alias
  # Here is Bar
  alias Foo.Bar
  # Here come the Baz
  # With a Qux!
  alias Foo.Baz.Qux
  ```
  """
  def fix(source) do
    Rfx.Ops.Credo.MultiAlias.rfx_source(source)
  end

end
