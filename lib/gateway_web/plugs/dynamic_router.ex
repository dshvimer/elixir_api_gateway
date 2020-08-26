defmodule GatewayWeb.DynamicRouter do
  import Plug.Conn
  alias Gateway.{Routing, Proxy}

  def init(opts), do: opts

  def call(conn, _opts) do
    Routing.get_table()
    |> Routing.match(conn.request_path)
    |> case do
      {:ok, upstream} ->
        conn
        |> request(upstream)
        |> handle_response(conn)

      {:error, _} ->
        render_error(conn)
    end
  end

  def request(conn, upstream) do
    {conn.method, upstream, body(conn), conn.req_headers}
    |> Proxy.forward()
    |> Proxy.response()
  end

  defp handle_response({:ok, status, body, headers}, conn) do
    conn
    |> prepend_resp_headers(headers)
    |> resp(status, body)
  end

  defp handle_response({:error, error}, conn) do
    conn
    |> put_status(:bad_request)
    |> Phoenix.Controller.json(error)
    |> halt()
  end

  defp body(conn) do
    case read_body(conn) do
      {:ok, "", %{assigns: %{raw_body: raw_body}}} -> raw_body
      {:ok, body, _} -> body
    end
  end

  defp render_error(conn) do
    conn
    |> put_status(:not_found)
    |> Phoenix.Controller.json(%{error: "Failed to match route."})
    |> halt()
  end
end
