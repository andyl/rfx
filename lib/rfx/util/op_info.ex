defmodule Rfx.Util.OpInfo do

  def key(modname) do
    modname
    |> to_string()
    |> String.replace("Rfx.Ops.", "")
    |> String.replace("Elixir.", "")
    |> String.split(".")
    |> Enum.map(&Macro.underscore/1)
    |> Enum.join("_")
    |> String.to_atom()
  end

  def name(modname) do
    modname
    |> to_string()
    |> String.replace("Rfx.Ops.", "")
    |> String.replace("Elixir.", "")
    |> String.split(".")
    |> Enum.map(&Macro.underscore/1)
    |> Enum.join(".")
  end

  def argspec(modname) do
    apply(modname, :argspec, [])
  end

  def info(modname) do
    apply(modname, :module_info, [])
  end
  
end
