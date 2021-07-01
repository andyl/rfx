defmodule Rfx.Edit.Credo.IoInspectDeleteTest do
  use ExUnit.Case

  alias Rfx.Edit.Credo.IoInspectDelete
  alias Rfx.Util.Tst

  require Tst

  examples = [
    {
      ~S(IO Inspect in Pipeline),
      ~S'''
      asdf() |> IO.inspect() |> qwer()
      ''', 
      ~S'''
      asdf() |> qwer()
      '''
    },
    {
      ~S(no change expected),
      "asdf",
      "asdf"
    },
  ]

  describe "#edit examples" do

    Tst.edit_tst(examples, IoInspectDelete)

  end
end
