defmodule Rfx.Ops do

  @moduledoc """
  Behavior for Rfx Operations moduiles.

  Each operation has an `edit` function which returned edited source code.  

  Each operation has functions that return a `Rfx.Change.List` for each Scope:
  `cl_code`, `cl_file`, `cl_project`, `cl_subapp`.

  """

  @doc """
  Generate a changelist for a piece of code.
  """
  @callback cl_code(any()) :: any()

  @doc """
  Generate a changelist for a file.
  """
  @callback cl_file(any()) :: any()

  @doc """
  Generate a changelist for a project.
  """
  @callback cl_project(any()) :: any()

  @doc """
  Generate a changelist for a subapp.

  Only works within Umbrella applications.
  """
  @callback cl_subapp(any()) :: any()
  
  @doc """
  Edit a piece of code, using Sourceror rules.

  The edit function can be delegated to an `Rfx.Edit.*`
  module.  

      defdelegate :edit, Rfx.Edit.Credo.MultiAlias

  See `Rfx.Edit` for more information.
  """
  @callback edit(String.t) :: String.t
  @callback edit(String.t, any()) :: String.t

  @optional_callbacks edit: 1, edit: 2
  
end
