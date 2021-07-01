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

end
