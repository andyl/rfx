defmodule Rfx.Edit.Credo.IoInspectCommentTest do
  use ExUnit.Case

  alias Rfx.Edit.Credo.IoInspectComment
  alias Rfx.Util.Tst

  require Tst

  examples = [
    {
      ~S(IO Inspect in Pipeline),
      ~S'''
      asdf() 
      |> IO.inspect() 
      |> qwer()
      ''', 
      ~S'''
      asdf() 
      # |> IO.inspect() 
      |> qwer()
      '''
    },
    {
      ~S(no change expected),
      "asdf",
      "asdf"
    },
  ]

  # describe "#edit examples" do
  #
  #   Tst.edit_tst(examples, IoInspectComment)
  #
  # end
end
