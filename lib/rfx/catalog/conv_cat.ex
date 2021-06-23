defmodule Rfx.Catalog.ConvCat do
  @moduledoc """
  Dynamically generate a catalog of Rfx ChangeReq Converters

  Introspects the BEAM environment for all modules in the `Rfx.Change.Convert.`
  namespace.

  Used to generate dynamic a catalog of Rfx ChangeReq Converters.  Developers
  can write their own Converters, and apply introspection mechanisms comparable
  those used for Mix Tasks.

  The Catalog is used by `rfxi` to dynamically generate list of conversion
  modules.
  """

  alias Rfx.Util.Introspect

  @doc """
  Return a list of all Rfx.Ops modules available in the Beam.
  """
  def all_conv do
    raw_conv()
  end

  @doc """
  Select Rfx operations in a given namespace.
  """
  def select_conv(namespace) when is_atom(namespace) do
    namespace
    |> Atom.to_string()
    |> Macro.camelize()
    |> select_conv()
  end

  def select_conv(namespace) do
    raw_conv(namespace)
    |> Enum.filter(&lib_module?/1)
  end

  defp lib_module?(module) when is_atom(module) do
    # not a test module...
    module
    |> Atom.to_string()
    |> lib_module?()
  end

  defp lib_module?(module) when is_binary(module) do
    # not a test module...
    ! Regex.match?(~r/Test$/, String.trim(module))
  end

  def raw_conv(namespace \\ "") do
    Introspect.modules_belonging_to_namespace("Rfx.Change.Convert." <> namespace)
  end

end
