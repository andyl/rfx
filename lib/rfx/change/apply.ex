defmodule Rfx.Change.Apply do

  # NEW

  def apply!(%{cmd: :file_create, src_path: srcpath}) do
    File.touch(srcpath) 
  end

  def apply!(%{cmd: :file_move, src_path: srcpath, tgt_path: tgtpath}) do
    File.rename(srcpath, tgtpath)
  end

  def apply!(%{cmd: :file_delete, src_path: srcpath}) do
    File.rm(srcpath)
  end

  def apply!(%{cmd: :dir_create, src_path: srcpath}) do
    File.mkdir(srcpath)
  end

  def apply!(%{cmd: :dir_move, src_path: srcpath, tgt_path: tgtpath}) do
    File.rename(srcpath, tgtpath)
  end

  def apply!(%{cmd: :dir_delete, src_path: srcpath}) do
    File.rmdir(srcpath)
  end
  
  # -------------------------------------------------------------------
  # came from Rfx.Cast...
  #
  # def apply!(%Req{text_req: editargs, file_req: nil}) do
  #   %Req{
  #     text_req: editargs |> Map.put(:output_apply!, TextReq.apply!(editargs)),
  #     file_req: nil
  #   }
  # end
  #
  # def apply!(%Req{file_req: fileargs, text_req: nil}) do
  #   %Req{
  #     file_req: fileargs |> Map.put(:output_apply!, FileReq.apply!(fileargs)),
  #     text_req: nil
  #   }
  # end
  #
  # def apply!(%Req{text_req: editargs, file_req: fileargs}) do
  #   %Req{
  #     text_req: editargs |> Map.put(:output_apply!, TextReq.apply!(editargs)),
  #     file_req: fileargs |> Map.put(:output_apply!, FileReq.apply!(fileargs))
  #   }
  # end

  # -------------------------------------------------------------------
  # came from Rfx.Req.File...
  #
  # def apply!(%{cmd: :file_create, src_path: srcpath}) do
  #   File.touch(srcpath) 
  # end
  #
  # def apply!(%{cmd: :file_move, src_path: srcpath, tgt_path: tgtpath}) do
  #   File.rename(srcpath, tgtpath)
  # end
  #
  # def apply!(%{cmd: :file_delete, src_path: srcpath}) do
  #   File.rm(srcpath)
  # end
  #
  # def apply!(%{cmd: :dir_create, src_path: srcpath}) do
  #   File.mkdir(srcpath)
  # end
  #
  # def apply!(%{cmd: :dir_move, src_path: srcpath, tgt_path: tgtpath}) do
  #   File.rename(srcpath, tgtpath)
  # end
  #
  # def apply!(%{cmd: :dir_delete, src_path: srcpath}) do
  #   File.rmdir(srcpath)
  # end

  # -------------------------------------------------------------------
  # came from Rfx.Req.Text...
  #
  
  # def apply!(%{file_path: path, diff: diff}) do
  #   new_source = path
  #                |> File.read!()
  #                |> Source.patch(diff)
  #   File.write(path, new_source)
  #   {:ok, "File #{path} updated with new content"}
  # end
  #
  # def apply!(%{edit_source: _source, diff: _}) do
  #   {:error, "Can only apply changes to a file."}
  # end



end
