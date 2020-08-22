defmodule Gateway.KeyTest do
  use Gateway.DataCase
  alias Gateway.Key

  describe "changeset" do
    test "key value is auto generated" do
      ch = Key.changeset(%Key{}, %{})
      assert ch.valid?
      assert {:ok, key} = Repo.insert(ch)
      refute is_nil(key.value)
    end

    test "key value is unique" do
      %Key{} |> Key.changeset(%{value: "123"}) |> Repo.insert()
      assert {:error, ch} = %Key{} |> Key.changeset(%{value: "123"}) |> Repo.insert()
      assert [value: {"has already been taken", _}] = ch.errors
    end
  end
end
