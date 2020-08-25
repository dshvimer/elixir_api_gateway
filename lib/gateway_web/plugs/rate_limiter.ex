defmodule GatewayWeb.RateLimiter do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    case check_rate(conn) do
      {:ok, _count} -> conn
      {:error, _count} -> render_error(conn)
    end
  end

  defp check_rate(%Plug.Conn{assigns: %{api_key: key}}) do
    ExRated.check_rate(key, 10_000, 5)
  end

  defp render_error(conn) do
    conn
    |> put_status(:forbidden)
    |> Phoenix.Controller.json(%{error: "Rate limit exceeded."})
    |> halt()
  end
end
