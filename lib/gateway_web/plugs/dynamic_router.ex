defmodule GatewayWeb.DynamicRouter do
  # import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    IO.inspect(conn.path_info)
    conn
  end
end
