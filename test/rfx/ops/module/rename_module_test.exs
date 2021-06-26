defmodule Rfx.Ops.Module.RenameModuleTest do
  use ExUnit.Case

  alias Rfx.Ops.Module.RenameModule

  @code """
  defmodule Bing do
  end
  """

  @infile "/tmp/bing.ex"
  # @outfile "/tmp/bong.ex"
  @args [old_name: "Bing", new_name: "Bong"]

  describe "#cl_code" do
    test "generating output" do
      output = RenameModule.cl_code(@code, [old_name: "Bing", new_name: "Bong"])
      assert output 
    end
  end

  describe "#cl_file" do
    test "generating output" do
      File.write!(@code, @infile)
      output = RenameModule.cl_file(@infile, @args)
      assert output 
    end
    
  end
end
