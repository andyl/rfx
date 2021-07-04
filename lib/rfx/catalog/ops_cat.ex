defmodule Rfx.Catalog.OpsCat do
  @moduledoc """
  Dynamically generate a catalog of Rfx Operations.

  Introspects the BEAM environment for all modules in the `Rfx.Ops.` namespace.

  Used to generate dynamic a catalog of Rfx Operations.  Developers can write
  their own Rfx Operations, and apply introspection mechanisms comparable those
  used for Mix Tasks.

  The Catalog is used by `rfxi` to generate generate a list of Rfx Operation
  modules.
  """

  alias Rfx.Util.Introspect

  @doc """
  Return a list of all Rfx.Ops modules available in the Beam.
  """
  def all_ops do
    raw_ops()
    |> Enum.filter(&has_propspec?/1)
    |> Enum.filter(&lib_module?/1)
  end

  @doc """
  Select Rfx operations in a given namespace.
  """
  def select_ops(namespace \\ "") do
    raw_ops(namespace)
    |> Enum.filter(&has_propspec?/1)
    |> Enum.filter(&lib_module?/1)
  end

  @doc """
  Select Rfx Operations by property.
  """
  def find_by_prop(key, value) do 
    all_ops()
    |> Enum.filter(&(has_prop?(&1, key, value))) 
  end

  def raw_ops(namespace \\ "") do
    Introspect.modules_belonging_to_namespace("Rfx.Ops." <> namespace)
  end

  defp lib_module?(module) when is_binary(module) do 
    # not a test module...
    ! Regex.match?(~r/Test$/, String.trim(module))
  end

  defp lib_module?(module) when is_atom(module) do
    module
    |> Atom.to_string()
    |> lib_module?()
  end

  defp has_propspec?(module) do
    module
    |> Introspect.has_function?({:propspec, 0})
  end

  defp has_prop?(module, key, val) do
    actual_val = apply(module, :propspec, []) |> Keyword.get(key, nil)
    val == actual_val
  end

end
