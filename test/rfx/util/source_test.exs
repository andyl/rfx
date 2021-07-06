defmodule Rfx.SourceTest do

  use ExUnit.Case

  alias Rfx.Util.Source

  describe "diff with json from Jason for" do
    names = ["insert", "delete", "insert_and_delete"]
    data = Enum.into(names, [], fn name ->
        {map, _} = Code.eval_file("test/rfx/util/testdata/#{name}_test.exs")
        map
      end
    )

    Enum.each data, fn input ->
      @name input.name
      @new input.new
      @old input.old

      test "#{@name}" do
        diff_as_json = Source.diff(@old, @new)
        |> Jason.encode!()
        diff = diff_as_json |> Jason.decode!()

        assert @new == Source.patch(@old, diff)
      end
    end
  end
end
