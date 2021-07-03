defmodule Rfx.Util.StrTest do

  use ExUnit.Case

  alias Rfx.Util.Str

  describe "#purge" do
    test "IO.inspect" do
      reg = ~r/\|> IO.inspect([^\|]*)/
      assert Str.purge(~S/|> IO.inspect()/, reg) == ""
      assert Str.purge(~S/|> IO.inspect(label: "ding")/, reg) == ""
      assert Str.purge(~S/bing() |> IO.inspect() |> pong()/, reg) == "bing() |> pong()"
    end
  end

  describe "#replace" do
    test "Simple Case" do
      regex = ~r/^(x*)(y*)(z*)/
      pattern = "\\1-\\2-\\3"
      assert Str.replace("xxyyyz", regex, pattern) 
      assert Str.replace("xxyyyz", regex, pattern) == "xx-yyy-z"
    end

    test "Comment Pipe" do
      regex = ~r/^( *)(\|> IO.inspect([^\|]*))/
      pattern = "\\1# \\2"
      assert Str.replace(" |> IO.inspect()", regex, pattern)  
      assert Str.replace(" |> IO.inspect()", regex, pattern) == " # |> IO.inspect()"
      assert Str.replace("|> IO.inspect()", regex, pattern) == "# |> IO.inspect()"
    end

    test "Uncomment Pipe" do
      regex = ~r/^( *)#( *\|> IO.inspect([^\|]*))/
      pattern = "\\1 \\2"
      assert Str.replace(" # |> IO.inspect()", regex, pattern)   
      assert Str.replace(" # |> IO.inspect()", regex, pattern) == "   |> IO.inspect()"
    end
  end

end
