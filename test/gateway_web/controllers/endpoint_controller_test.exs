defmodule GatewayWeb.EndpointControllerTest do
  use GatewayWeb.ConnCase

  alias Gateway.{Repo, Endpoint}

  @create_attrs %{upstream: "some endpoint", path: "some path"}
  @update_attrs %{upstream: "some updated endpoint", path: "some updated path"}
  @invalid_attrs %{upstream: nil, path: nil}

  def fixture(:endpoint) do
    {:ok, endpoint} = %Endpoint{} |> Endpoint.changeset(@create_attrs) |> Repo.insert()
    endpoint
  end

  describe "index" do
    test "lists all endpoints", %{conn: conn} do
      conn = get(conn, Routes.endpoint_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Endpoints"
    end
  end

  describe "new endpoint" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.endpoint_path(conn, :new))
      assert html_response(conn, 200) =~ "New Endpoint"
    end
  end

  describe "create endpoint" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.endpoint_path(conn, :create), endpoint: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.endpoint_path(conn, :show, id)

      conn = get(conn, Routes.endpoint_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Endpoint"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.endpoint_path(conn, :create), endpoint: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Endpoint"
    end
  end

  describe "edit endpoint" do
    setup [:create_endpoint]

    test "renders form for editing chosen endpoint", %{conn: conn, endpoint: endpoint} do
      conn = get(conn, Routes.endpoint_path(conn, :edit, endpoint))
      assert html_response(conn, 200) =~ "Edit Endpoint"
    end
  end

  describe "update endpoint" do
    setup [:create_endpoint]

    test "redirects when data is valid", %{conn: conn, endpoint: endpoint} do
      conn = put(conn, Routes.endpoint_path(conn, :update, endpoint), endpoint: @update_attrs)
      assert redirected_to(conn) == Routes.endpoint_path(conn, :show, endpoint)

      conn = get(conn, Routes.endpoint_path(conn, :show, endpoint))
      assert html_response(conn, 200) =~ "some updated endpoint"
    end

    test "renders errors when data is invalid", %{conn: conn, endpoint: endpoint} do
      conn = put(conn, Routes.endpoint_path(conn, :update, endpoint), endpoint: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Endpoint"
    end
  end

  describe "delete endpoint" do
    setup [:create_endpoint]

    test "deletes chosen endpoint", %{conn: conn, endpoint: endpoint} do
      conn = delete(conn, Routes.endpoint_path(conn, :delete, endpoint))
      assert redirected_to(conn) == Routes.endpoint_path(conn, :index)

      conn = get(conn, Routes.endpoint_path(conn, :show, endpoint))
      assert html_response(conn, 404) =~ "Not Found"
    end
  end

  defp create_endpoint(_) do
    endpoint = fixture(:endpoint)
    %{endpoint: endpoint}
  end
end
