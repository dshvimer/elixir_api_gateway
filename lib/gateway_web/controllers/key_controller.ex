defmodule GatewayWeb.KeyController do
  use GatewayWeb, :controller

  alias Gateway.{Key, Repo}

  def index(conn, _params) do
    keys = Repo.all(Key)
    render(conn, "index.html", keys: keys)
  end

  def new(conn, _params) do
    changeset = Key.changeset(%Key{}, %{})

    case Repo.insert(changeset) do
      {:ok, key} ->
        conn
        |> put_flash(:info, "Key created successfully.")
        |> redirect(to: Routes.key_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Error creating key.")
        |> redirect(to: Routes.key_path(conn, :index))

        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    key = Repo.get(Key, id)
    render(conn, "show.html", key: key)
  end

  def delete(conn, %{"id" => id}) do
    key = Repo.get(Key, id)
    {:ok, _key} = Repo.delete(key)

    conn
    |> put_flash(:info, "Key deleted successfully.")
    |> redirect(to: Routes.key_path(conn, :index))
  end
end
