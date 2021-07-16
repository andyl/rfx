defmodule Rfx.Edit.Credo.IoInspectUncommentTest do
  use ExUnit.Case

  alias Rfx.Edit.Credo.IoInspectUncomment
  alias Rfx.Util.Tst

  require Tst

  examples = [
    {
      ~S(IO Inspect in Pipeline),
      ~S'''
      asdf() 
      # |> IO.inspect() 
      |> qwer()
      ''', 
      ~S'''
      asdf() 
       |> IO.inspect() 
      |> qwer()
      '''
    },
    {
      ~S(no change expected),
      "asdf",
      "asdf"
    },
  ]


  describe "#edit examples" do

    Tst.edit_tst(examples, IoInspectUncomment)

  end
end
