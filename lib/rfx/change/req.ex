defmodule Rfx.Change.Req do

  @moduledoc """
  Req struct and support functions.

  A datastructure that represents the atomic refactoring changes to be made as
  part of a refactoring operation.

  The `Change.Req` struct has two elements:
  - *edit* (`Rfx.Req.Edit`) - the edit request 
  - *filesys* (`Rfx.Req.Filesys`) - the filesys request (create, move, delete)

  A Change.Req struct may contain an *edit* element, or a *filesys* element, or both.
  """

  defstruct [:edit, :filesys]

  alias Rfx.Change.Req

  # ----- Construction -----
  
  @doc """
  Create a new `Req`
  """
  def new(edit: editargs) do
    case Req.Edit.new(editargs) do
      {:ok, result} -> {:ok, %Req{edit: result}}
      {:error, msg} -> {:error, msg}
    end
  end

  def new(filesys: fileargs) do
    case Req.Filesys.new(fileargs) do
      {:ok, result} -> {:ok, %Req{filesys: result}}
      {:error, msg} -> {:error, msg}
    end
  end

  def new(edit: editargs, filesys: fsargs) do
   edit_result = case Req.Edit.new(editargs) do
      {:ok, result} -> {true, result}
      {:error, msg} -> {false, msg}
    end

    file_result = case Req.Filesys.new(fsargs) do
      {:ok, result} -> {true, result}
      {:error, msg} -> {false, msg}
    end

    case {edit_result, file_result} do
      {{true, edit_result}, {true, file_result}} -> {:ok, %Req{edit: edit_result, filesys: file_result}}
      {{true, _}, {false, msg}} -> {:error, msg}
      {{false, msg}, {true, _}} -> {:error, msg}
      {{false, msg1}, {false, msg2}} -> {:error, Enum.join([msg1, msg2], ", ")}
    end
  end

  # ----- Conversion -----
  
  def to_patch(_change) do
    :ok
  end

  def to_string(_change) do
    :ok
  end

  def to_json(_change) do
    :ok
  end

  def to_lsp(_change) do
    :ok 
  end

  # ----- Application -----
  
  def apply!(_change) do
    :ok
  end
  
end
