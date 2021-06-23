defmodule Rfx.Change.Request do

  @moduledoc """
  ChangeReq struct and support functions.

  A datastructure that represents the atomic refactoring changes to be made as
  part of a refactoring operation.

  The `Change.Req` struct has three elements:
  - *text_req* (`Rfx.Change.Req.TextReq`) - the text edit request 
  - *file_req* (`Rfx.Change.Req.FileReq`) - the file system request (create, move, delete)
  - *log* - (`Rfx.Change.Log`) - a log of change events (apply, cast)

  A Change.Request struct may contain a *text_req* element, a *file_req* element, a
  *log* element, or all.

  The request struct looks like this:

      %Change.Request{
        file_req: %{file request properties...},
        text_req: %{text request properties...},
        log: %{
          apply: [text: result, file: <result>],
          convert: %{
            to_string: "string",
            to_lsp: %{struct consumed by ElixirLS}
          }
        }
      }

  Note that when a Req is applied to the filesystem, the *text_req* element is
  applied first, then the *file_req* element.
  """

  defstruct [:text_req, :file_req, :log]

  alias Rfx.Change.Request
  alias Rfx.Change.Request.TextReq
  alias Rfx.Change.Request.FileReq

  # ----- Construction -----
  
  @doc """
  Create a new `Request`
  """
  def new(text_req: editargs) do
    case TextReq.new(editargs) do
      {:ok, result} -> {:ok, %Request{text_req: result}}
      {:error, msg} -> {:error, msg}
    end 
  end

  def new(file_req: fileargs) do
    case FileReq.new(fileargs) do
      {:ok, result} -> {:ok, %Request{file_req: result}}
      {:error, msg} -> {:error, msg}
    end 
  end

  def new(text_req: editargs, file_req: fsargs) do
   edit_result = case TextReq.new(editargs) do
      {:ok, result} -> {true, result}
      {:error, msg} -> {false, msg}
    end

    file_result = case FileReq.new(fsargs) do
      {:ok, result} -> {true, result}
      {:error, msg} -> {false, msg}
    end

    case {edit_result, file_result} do
      {{true, edit_result}, {true, file_result}} -> {:ok, %Request{text_req: edit_result, file_req: file_result}}
      {{true, _}, {false, msg}} -> {:error, msg}
      {{false, msg}, {true, _}} -> {:error, msg}
      {{false, msg1}, {false, msg2}} -> {:error, Enum.join([msg1, msg2], ", ")}
    end 
  end

  # ----- Convert -----
  
  def convert(changereq, type) do
    mod = Rfx.Catalog.ConvCat.select_conv(type) |> List.first()
    mod.changereq(changereq)
  end

  def convert!(changereq, type) do
    convert(changereq, type)
  end

  # ----- Apply -----
  
  def apply!(%Request{text_req: editargs, file_req: nil, log: log}) do
    result = [text: TextReq.apply!(editargs), file: nil]
    newlog = (log || %{}) |> Map.merge(%{apply: result})
    %Request{
      text_req: editargs,
      file_req: nil, 
      log: newlog
    }
  end

  def apply!(%Request{file_req: fileargs, text_req: nil, log: log}) do
    result = [text: nil, file: FileReq.apply!(fileargs)]
    newlog = (log || %{}) |> Map.merge(%{apply: result})
    %Request{
      file_req: fileargs |> Map.put(:output_apply!, FileReq.apply!(fileargs)),
      text_req: nil,
      log: newlog
    }
  end

  def apply!(%Request{text_req: editargs, file_req: fileargs, log: log}) do
    result = [text: TextReq.apply!(editargs), file: FileReq.apply!(fileargs)]
    newlog = (log || %{}) |> Map.merge(%{apply: result})
    %Request{
      text_req: editargs,
      file_req: fileargs,
      log: newlog
    }
  end

end
