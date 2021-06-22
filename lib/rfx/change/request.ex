defmodule Rfx.Change.Request do

  @moduledoc """
  ChangeReq struct and support functions.

  A datastructure that represents the atomic refactoring changes to be made as
  part of a refactoring operation.

  The `Change.Req` struct has three elements:
  - *text_req* (`Rfx.Change.Req.TextReq`) - the text edit request 
  - *file_req* (`Rfx.Change.Req.FileReq`) - the file system request (create, move, delete)
  - *log* - (`Rfx.Change.Log`) - a log of change events (apply, cast)

  A Change.Req struct may contain an *text_req* element, or a *file_req*
  element, or both.

  Note that when a Req is applied to the filesystem, the *text_req* element is
  applied first, then the *file_req* element.
  """

  defstruct [:text_req, :file_req, :log]

  alias Rfx.Change.Request
  alias Rfx.Change.Request.TextReq
  alias Rfx.Change.Request.FileReq

  # ----- Construction -----
  
  @doc """
  Create a new `Req`
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

  # ----- Conversion -----
  
  def to_string(%Request{text_req: editargs, file_req: fileargs}) do
    %Request{
      text_req: editargs |> Map.put(:output_to_string, TextReq.to_string(editargs)),
      file_req: fileargs
    }
  end

  def to_string(text_req: editargs) do
    %Request{
      text_req: editargs |> Map.put(:output_to_string, TextReq.to_string(editargs))
    }
  end

  def to_string(file_req: fileargs) do
    %Request{
      file_req: fileargs 
    }
  end

  # ----- Application -----
  
  # Move all these to Rfx.Apply
  # TextReq.apply! and FileReq.apply! need to be moved to Rfx.Apply (private functions)

  def apply!(%Request{text_req: editargs, file_req: nil}) do
    %Request{
      text_req: editargs |> Map.put(:output_apply!, TextReq.apply!(editargs)),
      file_req: nil
    }
  end

  def apply!(%Request{file_req: fileargs, text_req: nil}) do
    %Request{
      file_req: fileargs |> Map.put(:output_apply!, FileReq.apply!(fileargs)),
      text_req: nil
    }
  end

  def apply!(%Request{text_req: editargs, file_req: fileargs}) do
    %Request{
      text_req: editargs |> Map.put(:output_apply!, TextReq.apply!(editargs)),
      file_req: fileargs |> Map.put(:output_apply!, FileReq.apply!(fileargs))
    }
  end

end
