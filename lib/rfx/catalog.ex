defmodule Rfx.Catalog do
  @moduledoc """
  Dynamically generate a list of Rfx Operations.

  Introspects the BEAM environment for all modules in the `Rfx.Ops.` namespace.

  Used to generate dynamic a catalog of Rfx Operations.  Developers can write
  their own Rfx Operations, and apply introspection mechanisms comparable those
  used for Mix Tasks.

  The Catalog is used by `rfx_cli` to generate option lists.
  """

  @doc """
  Return a list of all Rfx.Ops modules available in the Beam.
  """
  def all do
    Rfx.Util.Introspect.modules_belonging_to_namespace("Rfx.Ops.")
  end
end
