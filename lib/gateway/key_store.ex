defmodule Gateway.KeyStore do
  alias Gateway.{Key, Repo}

  @doc """
  Given an API Key Value, will check the cache and database for it's existence.
  If it does not exist, the :not_found result will be cached to prevent future
  lookups.
  """
  @spec get(binary) :: {:ok, Key.t()} | {:error, :not_found}
  def get(key) do
    case cache_get(key) do
      {:ok, :skip} ->
        {:error, :not_found}

      {:ok, value} ->
        {:ok, value}

      {:error, :not_found} ->
        case disk_get(key) do
          {:ok, value} ->
            cache_set(key, value)
            {:ok, value}

          {:error, :not_found} ->
            cache_set(key, :not_found)
            {:error, :not_found}
        end
    end
  end

  @doc """
  Given an API Key Value, will check for it's existence in the database using
  Repo.
  """
  @spec disk_get(binary) :: {:ok, Key.t()} | {:error, :not_found}
  def disk_get(key) do
    case Repo.get_by(Key, value: key) do
      nil -> {:error, :not_found}
      value -> {:ok, value}
    end
  end

  @doc """
  Given an API Key Value, will check for it's existence in the cache using
  Cachex.

  A return value of `{:ok, %Key{}}` means the key was found in the cache.

  A return value of `{:ok, :skip}` means the key was not found recently, and
  the result is cached to prevent extra DB lookups

  A return value of `{:error, :not_found}` means the key was not found.
  """
  @spec cache_get(binary) :: {:ok, Key.t() | {:ok, :skip} | {:error, any}
  def cache_get(key) do
    case Cachex.get(:key_cache, key) do
      {:ok, :not_found} -> {:ok, :skip}
      {:ok, nil} -> {:error, :not_found}
      {:ok, value} -> {:ok, value}
      {:error, _error} -> {:error, :not_found}
    end
  end

  @doc """
  Given an API Key Value and Key struct, will save the record in cache using
  Cachex.
  """
  @spec cache_set(binary, Key.t()) :: {:ok, true} | {:error, any}
  def cache_set(key, value) do
    case Cachex.put(:key_cache, key, value) do
      {:ok, true} -> {:ok, true}
      {:error, error} -> {:error, error}
    end
  end
end
