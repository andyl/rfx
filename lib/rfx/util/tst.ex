defmodule Rfx.Util.Tst do

  @moduledoc """
  Helper functions used for testing.
  """

  @base_dir "/tmp/rfx_test_files"

  alias Rfx.Util.Str

  def base_dir do
    @base_dir
  end

  def gen_file(content) do
    base_dir() |> File.mkdir()
    fname = rand_fn()
    File.write(fname, content)
    fname
  end

  def gen_dir do
    base_dir() |> File.mkdir()
    dname = rand_dn()
    File.mkdir(dname)
    dname
  end

  def gen_proj(cmd) do
    base_dir() |> File.mkdir()
    base_dir() |> File.cd()
    [cmd | args] = String.split(cmd, " ")
    dname = Str.rand_str()
    System.cmd(cmd, args ++ [dname])
    base_dir() <> "/" <> dname
  end

  def rand_fn do
    base_dir() <> "/" <> Str.rand_str() <> ".ex"
  end

  def rand_dn do
    base_dir() <> "/" <> Str.rand_str()
  end

  defmacro edit_tst(examples, module) do
    quote do
      Enum.each unquote(examples), fn({testcase, original, expected}) ->
        @testcase testcase
        @original original |> String.trim()
        @expected expected |> String.trim()
        test "#{@testcase}" do
          assert @expected == apply(unquote(module), :edit, [@original])
        end
      end
    end
  end

end

