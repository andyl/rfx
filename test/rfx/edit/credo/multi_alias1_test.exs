defmodule Rfx.Edit.Credo.MultiAlias1Test do
  use ExUnit.Case

  alias Rfx.Edit.Credo.MultiAlias1, as: MultiAlias
  
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

      actual = MultiAlias.edit(source)

      assert actual == expected
    end

    @tag :pending
    test "using generated project" do
      proj_root = Tst.gen_proj("mix new")
      proj_name = proj_root |> String.split("/") |> Enum.reverse() |> Enum.at(0)
      test_file = proj_root <> "/lib/#{proj_name}.ex"
      test_code = File.read!(test_file) 
      new_code = MultiAlias.edit(test_code)

      IO.puts "---"
      IO.puts test_code
      IO.puts "---"
      IO.puts new_code
      IO.puts "---"

      assert test_code == new_code
    end

    @tag :pending
    test "using string-literal boilerplate code" do
      input_code = ~s'''
      module DemoMod do
        @moduledoc """
        Documentation for `DemoMod`.
        """

        @doc """
        Hello world.

        ## Examples
        
        iex> Wkid.hello()
        :world
        """
        
        def hello do
          :world  
        end
      end
      '''

      output_code = MultiAlias.edit(input_code)

      IO.puts output_code

      assert output_code == input_code
    end
  end
end
