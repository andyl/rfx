defmodule Rfx.Ops.Proto.MvFile do

  @behaviour Rfx.Ops

  @moduledoc """
  Test Operation that moves a file.

  This is a prototype operation used for demos and integration testing.

  """

  alias Rfx.Change.Request

  # ----- Argspec -----

  @impl true
  def argspec do
    [
      about: "MvFile - Use for Testing",
      status: :experimental, 
      options: [
        new_path: [
          short: "-n",
          long: "--new_path",
          value_name: "NEW_PATH",
          help: "New File PATH",
          required: true
        ]
      ]
    ] 
  end

  # ----- Changesets -----

  @impl true
  def cl_code(_path, _args \\ []) do
    []
  end

  @impl true
  def cl_file(old_path, [new_path: new_path]) do
    new = Path.expand(new_path)
    old = Path.expand(old_path)
    [Request.new(file_req: [cmd: :file_move, src_path: old, tgt_path: new])]
  end

  @impl true
  def cl_project(_old_path, _args \\ []) do
    []
  end

  @impl true
  def cl_subapp(_old_path, _args \\ []) do
    []
  end

  @impl true
  def cl_tmpfile(old_path, [new_path: new_path]) do
    new = Path.expand(new_path)
    old = Path.expand(old_path)
    [Request.new(file_req: [cmd: :file_move, src_path: old, tgt_path: new])]
  end

  # ----- Edit -----
  
  @impl true
  def edit(_source) do
    :ok
  end

end
