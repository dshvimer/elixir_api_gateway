defmodule Gateway.Routing do
  def match(table, path) do
    parts = Path.split(path)
    do_match(table, parts)
  end

  defp do_match(table, [head | tail]) do
    result = Map.get(table, head)

    cond do
      is_map(result) -> do_match(result, tail)
      is_binary(result) -> {:ok, Path.join([result | tail])}
      true -> {:error, :no_match}
    end
  end

  def build_table(endpoints) when is_list(endpoints) do
    Enum.reduce(endpoints, %{}, fn {path, upstream}, acc ->
      put_in(acc, Enum.map(Path.split(path), &Access.key(&1, %{})), upstream)
    end)
  end

  def get_table(), do: Application.get_env(:gateway, __MODULE__) |> Keyword.get(:table)
  def put_table(table), do: Application.put_env(:gateway, __MODULE__, table: table)
end
