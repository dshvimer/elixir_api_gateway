defmodule GatewayWeb.KeyControllerTest do
  use GatewayWeb.ConnCase

  alias Gateway.Access

  @create_attrs %{value: "some value"}
  @update_attrs %{value: "some updated value"}
  @invalid_attrs %{value: nil}

  def fixture(:key) do
    {:ok, key} = Access.create_key(@create_attrs)
    key
  end

  describe "index" do
    test "lists all keys", %{conn: conn} do
      conn = get(conn, Routes.key_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Keys"
    end
  end

  describe "new key" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.key_path(conn, :new))
      assert html_response(conn, 200) =~ "New Key"
    end
  end

  describe "create key" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.key_path(conn, :create), key: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.key_path(conn, :show, id)

      conn = get(conn, Routes.key_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Key"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.key_path(conn, :create), key: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Key"
    end
  end

  describe "edit key" do
    setup [:create_key]

    test "renders form for editing chosen key", %{conn: conn, key: key} do
      conn = get(conn, Routes.key_path(conn, :edit, key))
      assert html_response(conn, 200) =~ "Edit Key"
    end
  end

  describe "update key" do
    setup [:create_key]

    test "redirects when data is valid", %{conn: conn, key: key} do
      conn = put(conn, Routes.key_path(conn, :update, key), key: @update_attrs)
      assert redirected_to(conn) == Routes.key_path(conn, :show, key)

      conn = get(conn, Routes.key_path(conn, :show, key))
      assert html_response(conn, 200) =~ "some updated value"
    end

    test "renders errors when data is invalid", %{conn: conn, key: key} do
      conn = put(conn, Routes.key_path(conn, :update, key), key: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Key"
    end
  end

  describe "delete key" do
    setup [:create_key]

    test "deletes chosen key", %{conn: conn, key: key} do
      conn = delete(conn, Routes.key_path(conn, :delete, key))
      assert redirected_to(conn) == Routes.key_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.key_path(conn, :show, key))
      end
    end
  end

  defp create_key(_) do
    key = fixture(:key)
    %{key: key}
  end
end
