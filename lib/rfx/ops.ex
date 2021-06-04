defmodule Rfx.Ops do

  @moduledoc """
  Behavior for Rfx operation.

  Each operation has an edit function which returned edited source code.  Each
  operation has `cl_*` functions  that return a Changelist for each Scope:
  code, file, project, subapp.
  """

  @doc "Edit a piece of code, using Sourceror rules."
  @callback edit(String.t) :: String.t

  @doc "Generate a changelist for a piece of code."
  @callback cl_code(any()) :: any()

  @doc "Generate a changelist for a file."
  @callback cl_file(any()) :: any()

  @doc "Generate a changelist for a project."
  @callback cl_project(any()) :: any()

  @doc "Generate a changelist for a subapp."
  @callback cl_subapp(any()) :: any()
  
end
