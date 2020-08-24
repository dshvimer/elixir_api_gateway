defmodule Gateway.KeStoreyTest do
  use Gateway.DataCase
  alias Gateway.{Key, KeyStore, Repo}

  describe "get/1" do
    test "returns error if cache returned :not_found" do
      value = Ecto.UUID.generate()
      {:ok, true} = Cachex.put(:key_cache, value, :not_found)
      assert {:error, :not_found} = KeyStore.get(value)
    end

    test "returns key if existed in cache" do
      {:ok, key} = %Key{} |> Key.changeset(%{}) |> Repo.insert()
      {:ok, true} = Cachex.put(:key_cache, key.value, key)
      assert {:ok, %Key{id: id}} = KeyStore.get(key.value)
      assert id == key.id
    end

    test "returns key if existed on disk" do
      {:ok, key} = %Key{} |> Key.changeset(%{}) |> Repo.insert()
      assert {:ok, %Key{id: id}} = KeyStore.get(key.value)
      assert id == key.id
    end

    test "returns error key not found, caches the :not_found result" do
      value = Ecto.UUID.generate()
      assert {:error, :not_found} = KeyStore.get(value)
      assert {:ok, :not_found} = Cachex.get(:key_cache, value)
    end
  end

  describe "disk_get/1" do
    test "returns the key if it exists" do
      {:ok, key} = %Key{} |> Key.changeset(%{}) |> Repo.insert()
      assert {:ok, %Key{id: id}} = KeyStore.disk_get(key.value)
      assert id == key.id
    end

    test "returns error if key does not exists" do
      assert {:error, :not_found} = KeyStore.disk_get("some value")
    end
  end

  describe "cache_get/1" do
    test "returns the key if found" do
      {:ok, key} = %Key{} |> Key.changeset(%{}) |> Repo.insert()
      {:ok, true} = Cachex.put(:key_cache, key.value, key)
      assert {:ok, %Key{id: id}} = KeyStore.cache_get(key.value)
      assert id == key.id
    end

    test "returns ok with :skip if value was cached as :not_found" do
      value = Ecto.UUID.generate()
      {:ok, true} = Cachex.put(:key_cache, value, :not_found)
      assert {:ok, :skip} = KeyStore.cache_get(value)
    end

    test "returns error if value was not found" do
      assert {:error, :not_found} = KeyStore.cache_get(Ecto.UUID.generate())
    end
  end

  describe "cache_set/1" do
    test "returns ok signal on success" do
      {:ok, key} = %Key{} |> Key.changeset(%{}) |> Repo.insert()
      assert {:ok, true} = KeyStore.cache_set(key.value, key)
      assert {:ok, %Key{id: id}} = Cachex.get(:key_cache, key.value)
      assert id == key.id
    end
  end
end
