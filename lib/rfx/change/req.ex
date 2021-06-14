defmodule Rfx.Change.Req do

  @moduledoc """
  ChangeReq struct and support functions.

  A datastructure that represents the atomic refactoring changes to be made as
  part of a refactoring operation.

  The `Change.Req` struct has two elements:
  - *text_req* (`Rfx.Req.TextReq`) - the text edit request 
  - *file_req* (`Rfx.Req.FileReq`) - the file system request (create, move, delete)

  A Change.Req struct may contain an *text_req* element, or a *file_req*
  element, or both.

  Note that when a Req is applied to the filesystem, the *text_req* element is
  applied first, then the *file_req* element.
  """

  defstruct [:text_req, :file_req]

  alias Rfx.Change.Req
  alias Rfx.Change.Req.TextReq
  alias Rfx.Change.Req.FileReq

  # ----- Construction -----
  
  @doc """
  Create a new `Req`
  """
  def new(text_req: editargs) do
    case TextReq.new(editargs) do
      {:ok, result} -> {:ok, %Req{text_req: result}}
      {:error, msg} -> {:error, msg}
    end 
  end

  def new(file_req: fileargs) do
    case FileReq.new(fileargs) do
      {:ok, result} -> {:ok, %Req{file_req: result}}
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
      {{true, edit_result}, {true, file_result}} -> {:ok, %Req{text_req: edit_result, file_req: file_result}}
      {{true, _}, {false, msg}} -> {:error, msg}
      {{false, msg}, {true, _}} -> {:error, msg}
      {{false, msg1}, {false, msg2}} -> {:error, Enum.join([msg1, msg2], ", ")}
    end 
  end

  # ----- Conversion -----
  
  def to_string(%Req{text_req: editargs, file_req: fileargs}) do
    %Req{
      text_req: editargs |> Map.put(:result, TextReq.to_string(editargs)),
      file_req: fileargs
    }
  end

  def to_string(text_req: editargs) do
    %Req{
      text_req: editargs |> Map.put(:result, TextReq.to_string(editargs))
    }
  end

  def to_string(file_req: fileargs) do
    %Req{
      file_req: fileargs 
    }
  end

  # ----- Application -----
  
  def apply!(%Req{text_req: editargs, file_req: fileargs}) do
    %Req{
      text_req: editargs |> Map.put(:result, TextReq.apply!(editargs)),
      file_req: fileargs |> Map.put(:result, FileReq.apply!(fileargs))
    }
  end

  def apply!(text_req: editargs) do
    %Req{
      text_req: editargs |> Map.put(:result, TextReq.apply!(editargs))
    }
  end

  def apply!(file_req: fileargs) do
    %Req{
      file_req: fileargs |> Map.put(:result, FileReq.apply!(fileargs))
    }
  end

end
