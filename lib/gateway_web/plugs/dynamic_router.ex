defmodule GatewayWeb.DynamicRouter do
  import Plug.Conn
  alias Gateway.Routing

  def init(options), do: options

  def call(conn, _opts) do
    Routing.get_table()
    |> Routing.match(conn.path_info)
    |> case do
      {:ok, upstream} -> ReverseProxyPlug.call(conn, upstream: upstream)
      {:error, _} -> render_error(conn)
    end
  end

  defp render_error(conn) do
    conn
    |> put_status(:not_found)
    |> Phoenix.Controller.json(%{error: "Failed to match route."})
    |> halt()
  end
end
