defmodule Sourceror.MultiAliasTest do

  use ExUnit.Case

  test "input/output without changes" do
    str = "alias Foo.{Bar, Buz.Bax}"
    out = str 
          |> Sourceror.parse_string() 
          |> elem(1) 
          |> Sourceror.to_string() 
    assert str == out
  end

end
