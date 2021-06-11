defmodule Rfx.Edit do

  @moduledoc """
  Behavior for Rfx Edit modules.

  Every Rfx Operation (`Rfx.Ops`) has an `edit` function.  The `edit` function
  can be large and difficult to test.  It sometimes makes sense to break out
  the edit logic into it's own module.

  Within an Ops module, the edit function can be delegated to `Rfx.Edit.*`:

      defdelegate :edit, Rfx.Edit.Credo.MultiAlias

  Independent Edit modules make it easier to test and version Edit functions.
  """

  @doc "Edit a piece of code, using Sourceror rules."

  @callback edit(String.t) :: String.t

  @callback edit(String.t, any()) :: String.t

  @optional_callbacks edit: 1, edit: 2
  
end
