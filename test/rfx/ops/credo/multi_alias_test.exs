defmodule Rfx.Ops.Credo.MultiAliasTest do
  use ExUnit.Case

  alias Rfx.Ops.Credo.MultiAlias

  doctest MultiAlias

  describe "#rfx_code" do
    test "expands multi alias" do
      source = """
      alias Foo.{Bar, Baz.Qux}
      """

      expected =
      """
      alias Foo.Bar
      alias Foo.Baz.Qux
      """
      |> String.trim()

      actual = MultiAlias.rfx_code(source)
      assert actual == expected
    end

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

      actual = MultiAlias.rfx_code(source)

      assert actual == expected
    end

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

      actual = Examples.Credo.MultiAlias.fix(source)

      assert actual == expected
    end
  end

  describe "#rfx_file!" do
    test "placeholder1" do
      msg = Tst.rand_str(50)
      fnz = Tst.gen_file(msg)
      txt = File.read!(fnz)
      assert msg == txt
    end
  end

  describe "#rfx_project!" do
    test "placeholder2" do
      assert true
    end
  end

end
