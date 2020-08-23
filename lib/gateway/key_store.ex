defmodule Gateway.KeyStore do
  alias Gateway.{Key, Repo}

  def get(key) do
    case cache_get(key) do
      # This key has already been checked, and was not found.
      {:ok, :not_found} ->
        {:error, :not_found}

      {:ok, value} ->
        {:ok, value}

      {:error, :not_found} ->
        case disk_get(key) do
          {:ok, value} ->
            case cache_set(key, value) do
              {:ok, true} -> {:ok, value}
              {:error, error} -> {:error, error}
            end

          {:error, :not_found} ->
            # Cache the :not_found result to avoid trips to DB
            cache_set(key, :not_found)
            {:error, :not_found}
        end
    end
  end

  @spec disk_get(any) :: {:error, :not_found} | {:ok, any}
  def disk_get(key) do
    case Repo.get_by(Key, value: key) do
      nil -> {:error, :not_found}
      value -> {:ok, value}
    end
  end

  def cache_get(key) do
    case Cachex.get(:key_cache, key) do
      {:ok, nil} -> {:error, :not_found}
      {:ok, value} -> {:ok, value}
      {:error, error} -> {:error, error}
    end
  end

  def cache_set(key, value) do
    case Cachex.put(:key_cache, key, value) do
      {:ok, true} -> {:ok, true}
      {:error, error} -> {:error, error}
    end
  end
end
