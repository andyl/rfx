defmodule Rfx.Change.Log do
  @moduledoc """
  A log of change events.

  The change request data structure looks like:

      %Change.Req{
        file_req: %{file request properties...},
        text_req: %{text request properties...},
        log: %{
          apply: %{results from applying a change request...},
          convert: %{
            to_string: "string_value", 
            to_lsp: %{struct consumed by ElixirLS}
          }
        }
      }

  Each operation (`Rfx.Ops.*`) emits a set of change requests with `file_req` and/or
  `text_req` elements.

  The changeset data may be passed to `#apply` or `#convert` functions, which
  annotate the changeset with log entries.
  """
end
