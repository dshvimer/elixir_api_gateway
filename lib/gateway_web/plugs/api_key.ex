defmodule GatewayWeb.ApiKey do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> get_req_header("x-api-key")
    |> authenticate()
    |> case do
      {:ok, key} ->
        assign(conn, :api_key, key)

      {:error, error} ->
        render_error(conn, error)
    end
  end

  defp authenticate([key]), do: Gateway.KeyStore.get(key)
  defp authenticate([]), do: {:error, :missing_key}

  defp render_error(conn, :missing_key) do
    conn
    |> put_status(:forbidden)
    |> Phoenix.Controller.json(%{error: "API key is missing."})
    |> halt()
  end

  defp render_error(conn, :not_found) do
    conn
    |> put_status(:forbidden)
    |> Phoenix.Controller.json(%{error: "API key is invalid."})
    |> halt()
  end
end
