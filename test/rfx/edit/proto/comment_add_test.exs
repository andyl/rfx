defmodule Rfx.Edit.Proto.CommentAddTest do

  use ExUnit.Case

  alias Rfx.Edit.Proto.CommentAdd

  doctest CommentAdd

  test "without label" do
    code = "My Awesome Code"
    expected = "# TestComment\n#{code}" 
    assert CommentAdd.edit(code) == expected
  end

  test "with label" do
    code = "My Awesome Code"
    expected = "# TestComment (asdf)\n#{code}" 
    assert CommentAdd.edit(code, label: "asdf") == expected
  end
end
