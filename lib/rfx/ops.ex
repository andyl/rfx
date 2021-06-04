defmodule Rfx.Ops do

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
