defmodule Rfx.Ops.Credo.MultiAlias.EditorTest do
  use ExUnit.Case

  alias Rfx.Ops.Credo.MultiAlias.Editor
  
  @base_source """
  alias Foo.{Bar, Baz.Qux}
  """

  @base_expected """
  alias Foo.Bar
  alias Foo.Baz.Qux
  """ |> String.trim()

  describe "#edit" do
    @tag :pending
    test "expands multi alias" do
      actual = Editor.edit(@base_source)
      assert actual == @base_expected
    end

    @tag :pending
    test "no change required" do
      actual = Editor.edit(@base_expected)
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
        # Here is Bar
        # Multi alias example
        # Opening the multi alias
        alias Foo.Bar
        # Here come the Baz
        # With a Qux!
        alias Foo.Baz.Qux

        # End of the demo :)
        """
        |> String.trim()

      actual = Editor.edit(source)

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

      actual = Editor.edit(source)

      assert actual == expected
    end

    @tag :pending
    test "using generated project" do
      root = Tst.gen_proj("mix new")
      proj = root |> String.split("/") |> Enum.reverse() |> Enum.at(0)
      file = root <> "/lib/#{proj}.ex"
      {:ok, code} = File.read(file)
      new_code = Editor.edit(code)
      File.write("/tmp/one.ex", code)
      File.write("/tmp/two.ex", new_code)
      assert code == new_code
    end
  end


end
