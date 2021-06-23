defmodule Rfx.Ops.Proto.MvFileTest do
  use ExUnit.Case

  alias Rfx.Ops.Proto.MvFile
  # alias Rfx.Util.Tst

  @base_source """
  InputSource
  """

  describe "#cl_code" do
    assert [] == MvFile.cl_code(@base_source, [new_path:  "/tmp/asdf.txt"])
  end

end
