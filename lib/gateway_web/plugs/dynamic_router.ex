defmodule GatewayWeb.DynamicRouter do
  import Plug.Conn
  alias Gateway.Routing

  def init(opts), do: opts

  def call(conn, _opts) do
    Routing.get_table()
    |> Routing.match(conn.request_path)
    |> case do
      {:ok, upstream} ->
        conn
        |> forward(upstream)
        |> response(conn)

      {:error, _} ->
        render_error(conn)
    end
  end

  defp render_error(conn) do
    conn
    |> put_status(:not_found)
    |> Phoenix.Controller.json(%{error: "Failed to match route."})
    |> halt()
  end

  defp response({:ok, response}, conn) do
    resp_headers = normalize_headers(response.headers)

    conn
    |> prepend_resp_headers(resp_headers)
    |> resp(response.status_code, response.body)
  end

  defp response({:error, _reason}, conn) do
    conn
    |> put_status(:bad_request)
    |> Phoenix.Controller.json(%{error: "Error forwarding request."})
    |> halt()
  end

  defp forward(conn, upstream) do
    %HTTPoison.Request{
      method: method(conn),
      url: upstream,
      body: body(conn),
      headers: headers(conn, upstream)
    }
    |> IO.inspect()
    |> HTTPoison.request()
  end

  defp headers(conn, upstream) do
    %URI{host: host, port: port} = URI.parse(upstream)

    headers =
      conn.req_headers
      |> normalize_headers()
      |> Enum.filter(&keep_header?/1)

    [{"host", "#{host}:#{port}"}] ++ headers
  end

  defp keep_header?({"x-api-key", _}), do: false
  defp keep_header?({"host", _}), do: false
  defp keep_header?(_), do: true

  defp normalize_headers(headers) do
    headers
    |> downcase_headers
    |> remove_hop_by_hop_headers
  end

  defp downcase_headers(headers) do
    headers
    |> Enum.map(fn {header, value} -> {String.downcase(header), value} end)
  end

  defp remove_hop_by_hop_headers(headers) do
    hop_by_hop_headers = [
      "te",
      "transfer-encoding",
      "trailer",
      "connection",
      "keep-alive",
      "proxy-authenticate",
      "proxy-authorization",
      "upgrade"
    ]

    headers
    |> Enum.reject(fn {header, _} -> Enum.member?(hop_by_hop_headers, header) end)
  end

  defp body(conn) do
    case read_body(conn) do
      {:ok, "", %{assigns: %{raw_body: raw_body}}} -> raw_body
      {:ok, body, _} -> body
    end
  end

  defp method(conn), do: conn.method |> String.downcase() |> String.to_atom()
end
