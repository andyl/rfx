defmodule Rfx.Edit.Credo.MultiAlias1Test do
  use ExUnit.Case

  alias Rfx.Edit.Credo.MultiAlias1, as: MultiAlias
  alias Rfx.Util.Tst

  require Tst

  examples = [
    {
      ~S(expand multi-alias),
      ~S'''
      alias Foo.{Bar, Baz.Qux}
      ''', 
      ~S'''
      alias Foo.Bar
      alias Foo.Baz.Qux
      '''
    },
    {
      ~S(no change expected),
      "asdf",
      "asdf"
    },
    {
      ~S(preserve comments),
      ~S'''
      # Multi alias example
      alias Foo.{ # Opening the multi alias
        Bar, # Here is Bar
        # Here come the Baz
        Baz.Qux # With a Qux!
        }

      # End of the demo :)
      ''', 
      ~S'''
      # Multi alias example
      # Opening the multi alias
      # Here is Bar
      alias Foo.Bar
      # Here come the Baz
      # With a Qux!
      alias Foo.Baz.Qux

      # End of the demo :)
      '''
    },
    {
      ~S(does not misplace comments above or below),
      ~S'''
      # A
      :a

      alias Foo.{Bar, Baz,
      Qux}

      :b # B
      ''',
      ~S''' 
      # A
      :a

      alias Foo.Bar
      alias Foo.Baz
      alias Foo.Qux

      # B
      :b
      '''
    }
  ]

  describe "#edit examples" do

    Tst.edit_tst(examples, MultiAlias)

    test "using generated project" do
      proj_root = Tst.gen_proj("mix new")
      proj_name = proj_root |> String.split("/") |> Enum.reverse() |> Enum.at(0)
      test_file = proj_root <> "/lib/#{proj_name}.ex"
      test_code = File.read!(test_file) 
      new_code = MultiAlias.edit(test_code)

      assert test_code == new_code <> "\n"
    end

    test "using string-literal boilerplate code" do
      input_code = ~S'''
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
      ''' |> Code.format_string!() |> IO.iodata_to_binary()

      output_code = MultiAlias.edit(input_code) |> Code.format_string!() |> IO.iodata_to_binary()

      assert output_code == input_code
    end
  end
end
