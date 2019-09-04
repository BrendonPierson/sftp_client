defmodule SFTPClient.ConnHelper do
  @moduledoc false

  alias SFTPClient.Config
  alias SFTPClient.Conn

  def build_conn(config_or_opts \\ []) do
    %Conn{
      config: Config.new(config_or_opts),
      channel_pid: :channel_pid_stub,
      conn_ref: :conn_ref_stub
    }
  end
end
