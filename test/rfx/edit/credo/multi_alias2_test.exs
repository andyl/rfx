defmodule Rfx.Edit.Credo.MultiAlias2Test do
  use ExUnit.Case

  alias Rfx.Edit.Credo.MultiAlias2, as: MultiAlias
  
  @base_source """
  alias Foo.{Bar, Baz.Qux}
  """

  @base_expected """
  alias Foo.Bar
  alias Foo.Baz.Qux
  """ |> String.trim()

  describe "#edit" do
    test "expands multi alias" do
      actual = MultiAlias.edit(@base_source)
      assert actual == @base_expected
    end

    test "no change required" do
      actual = MultiAlias.edit(@base_expected)
      assert actual == @base_expected
    end

    @tag :pending
    test "preserves comments" do
      source = """
      # Multi alias example
      alias Foo.{ # Opening the multi alias
        Bar, # Here is Bar
        # Here come the Baz
        Baz.Qux # With a Qux!
        }

      # End of the demo :)
      """

      expected =
        """
        # Multi alias example
        # Opening the multi alias
        # Here is Bar
        alias Foo.Bar
        # Here come the Baz
        # With a Qux!
        alias Foo.Baz.Qux

        # End of the demo :)
        """
        |> String.trim()

      actual = MultiAlias.edit(source)

      IO.puts "--\n" <> expected
      IO.puts "--\n" <> actual

      assert actual == expected
    end

    @tag :pending
    test "does not misplace comments above or below" do
      source = """
      # A
      :a

      alias Foo.{Bar, Baz,
      Qux}

      :b # B
      """

      expected = """
        # A
        :a

        alias Foo.Bar
        alias Foo.Baz
        alias Foo.Qux

        # B
        :b
        """
        |> String.trim()

      actual = MultiAlias.edit(source)

      assert actual == expected
    end

    @tag :pending
    test "using generated project" do
      root = Tst.gen_proj("mix new")
      proj = root |> String.split("/") |> Enum.reverse() |> Enum.at(0)
      file = root <> "/lib/#{proj}.ex"
      code = File.read!(file) |> Code.format_string!() |> IO.iodata_to_binary()
      new_code = MultiAlias.edit(code) |> String.replace("\\n", "\n") |> Code.format_string!() |> IO.iodata_to_binary()
      File.write("/tmp/one.ex", code)
      File.write("/tmp/two.ex", new_code)

      assert code == new_code
    end
  end

end
