defmodule Rfx.Change.Set do

  @moduledoc false

  # ----- Convert -----
  
  def convert(changeset, type) do
    changeset
    |> Enum.map(&(Rfx.Change.Request.convert(&1, type)))
  end

  def convert!(changeset, type) do
    changeset
    |> Enum.map(&(Rfx.Change.Request.convert!(&1, type)))
  end

  # ----- Apply -----

  def apply(changeset) do
    changeset
    |> Enum.map(&Rfx.Change.Request.apply!/1)
  end

  def apply!(changeset) do
    changeset
    |> Enum.map(&Rfx.Change.Request.apply!/1)
  end

end
