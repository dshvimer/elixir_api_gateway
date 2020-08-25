defmodule Gateway.EndpointTest do
  use Gateway.DataCase
  alias Gateway.Endpoint

  @valid_params %{upstream: "/", path: "/"}

  describe "changeset" do
    test "valid params" do
      assert {:ok, _} = %Endpoint{} |> Endpoint.changeset(@valid_params) |> Repo.insert()
    end

    test "path is unique" do
      %Endpoint{}
      |> Endpoint.changeset(%{upstream: "/", path: "/123"})
      |> Repo.insert()

      {:error, ch} =
        %Endpoint{}
        |> Endpoint.changeset(%{upstream: "/", path: "/123"})
        |> Repo.insert()

      assert {"has already been taken", constraint} = ch.errors[:path]
      assert [constraint: :unique, constraint_name: "endpoints_path_index"] = constraint
    end

    test "path is required" do
      ch = Endpoint.changeset(%Endpoint{}, Map.delete(@valid_params, :path))
      refute ch.valid?
      assert [path: {"can't be blank", [validation: :required]}] = ch.errors
    end

    test "upstream is required" do
      ch = Endpoint.changeset(%Endpoint{}, Map.delete(@valid_params, :upstream))
      refute ch.valid?
      assert [upstream: {"can't be blank", [validation: :required]}] = ch.errors
    end
  end
end
