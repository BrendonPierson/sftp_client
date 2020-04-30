defmodule SFTPClient.Operations.StreamFile do
  @moduledoc """
  A module that provides functions to create streams from and to files on an
  SFTP server.
  """

  alias SFTPClient.Conn
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.FileInfo
  alias SFTPClient.Stream, as: SFTPStream

  @doc """
  Creates a stream that allows reading from and writing to the server.
  """
  @spec stream_file(Conn.t(), Path.t()) ::
          {:ok, SFTPStream.t()} | {:error, SFTPClient.error()}
  def stream_file(%Conn{} = conn, path) do
    stream_file_no_bang(conn, path, [])
  end

  @doc """
  Creates a stream that allows reading from and writing to the server using the
  specified chunk size.
  """
  @spec stream_file(Conn.t(), Path.t(), non_neg_integer) ::
          {:ok, SFTPStream.t()} | {:error, SFTPClient.error()}
  def stream_file(%Conn{} = conn, path, chunk_size) do
    stream_file_no_bang(conn, path, [chunk_size])
  end

  defp stream_file_no_bang(conn, path, args) do
    case FileInfo.file_info(conn, path) do
      {:ok, %{type: :regular}} ->
        {:ok, apply(__MODULE__, :stream_file!, [conn, path | args])}

      {:ok, _} ->
        {:error, %OperationError{reason: :no_such_file}}

      error ->
        error
    end
  end

  @doc """
  Creates a stream that allows reading from and writing to the server.
  """
  @spec stream_file!(Conn.t(), Path.t()) :: SFTPStream.t()
  def stream_file!(%Conn{} = conn, path) do
    %SFTPStream{conn: conn, path: path}
  end

  @doc """
  Creates a stream that allows reading from and writing to the server using the
  specified chunk size.
  """
  @spec stream_file!(Conn.t(), Path.t(), non_neg_integer) :: SFTPStream.t()
  def stream_file!(%Conn{} = conn, path, chunk_size) do
    %SFTPStream{conn: conn, path: path, chunk_size: chunk_size}
  end
end
