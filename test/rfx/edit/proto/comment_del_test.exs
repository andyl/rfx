defmodule Rfx.Edit.Proto.CommentDelTest do

  use ExUnit.Case

  alias Rfx.Edit.Proto.CommentDel

  doctest CommentDel

  test "without label" do
    code = "My Awesome Code\n# TestComment"
    expected = "My Awesome Code"
    assert CommentDel.edit(code) == expected
  end

  test "with label" do
    code = "# TestComment (asdf)\nMy Awesome Code" 
    expected = "My Awesome Code"
    assert CommentDel.edit(code, label: "asdf") == expected
  end
end
