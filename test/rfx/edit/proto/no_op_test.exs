defmodule Rfx.Edit.Proto.NoOpTest do

  use ExUnit.Case

  alias Rfx.Edit.Proto.NoOp

  doctest NoOp

  test "makes no changes" do
    code = "My Awesome Code"
    assert NoOp.edit(code) == code
  end
end
