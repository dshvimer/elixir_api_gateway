defmodule Gateway.Routing do
  use GenServer
  alias Gateway.{Endpoint, Repo}

  def match(table, path) do
    # Maybe URI.parse is better?
    parts = Path.split(path)
    do_match(table, parts)
  end

  defp do_match(_table, []), do: {:error, :no_match}

  defp do_match(table, [head | tail]) do
    result = Map.get(table, head)

    cond do
      is_map(result) -> do_match(result, tail)
      is_binary(result) -> {:ok, Path.join([result | tail])}
      true -> {:error, :no_match}
    end
  end

  def build_table([]), do: %{"/" => "/"}

  def build_table(endpoints) when is_list(endpoints) do
    Enum.reduce(endpoints, %{}, fn {path, upstream}, acc ->
      put_in(acc, Enum.map(Path.split(path), &Access.key(&1, %{})), upstream)
    end)
  end

  def load!() do
    Endpoint
    |> Repo.all()
    |> Enum.map(&{&1.path, &1.upstream})
    |> build_table()
    |> put_table()
  end

  defp put_table(table), do: Application.put_env(:gateway, __MODULE__, table: table)

  def get_table(), do: Application.get_env(:gateway, __MODULE__) |> Keyword.get(:table)
  def start_link(arg), do: GenServer.start_link(__MODULE__, arg)
  def init(_), do: {load!(), nil}
end
