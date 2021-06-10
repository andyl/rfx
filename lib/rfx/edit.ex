defmodule Rfx.Edit do

  @moduledoc """
  Behavior for Rfx Edit modules.

  Every Rfx Operation (`Rfx.Ops`) has an edit function.  The edit function can
  be large and difficult to test.  It sometimes makes sense to break out the
  edit logic into it's own module.

  Within an Ops module, the edit function can be delegated to `Rfx.Edit.*`:

      defdelegate :edit, Rfx.Edit.Credo.MultiAlias

  Independant Edit modules make it easier to test and version Edit functions.
  """

  @doc "Edit a piece of code, using Sourceror rules."
  @callback edit(String.t) :: String.t
  
end
