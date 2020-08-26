defmodule GatewayWeb.EndpointController do
  use GatewayWeb, :controller

  alias Gateway.{Endpoint, Repo}

  def index(conn, _params) do
    endpoints = Repo.all(Endpoint)
    render(conn, "index.html", endpoints: endpoints)
  end

  def new(conn, _params) do
    changeset = Endpoint.changeset(%Endpoint{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"endpoint" => endpoint_params}) do
    changeset = Endpoint.changeset(%Endpoint{}, endpoint_params)

    case Repo.insert(changeset) do
      {:ok, endpoint} ->
        conn
        |> put_flash(:info, "Endpoint created successfully.")
        |> redirect(to: Routes.endpoint_path(conn, :show, endpoint))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Endpoint, id) do
      nil ->
        conn
        |> put_status(404)
        |> put_view(GatewayWeb.ErrorView)
        |> render("404.html")

      endpoint ->
        render(conn, "show.html", endpoint: endpoint)
    end
  end

  def edit(conn, %{"id" => id}) do
    endpoint = Repo.get(Endpoint, id)
    changeset = Endpoint.changeset(endpoint, %{})
    render(conn, "edit.html", endpoint: endpoint, changeset: changeset)
  end

  def update(conn, %{"id" => id, "endpoint" => endpoint_params}) do
    endpoint = Repo.get(Endpoint, id)
    changeset = Endpoint.changeset(endpoint, endpoint_params)

    case Repo.update(changeset) do
      {:ok, endpoint} ->
        conn
        |> put_flash(:info, "Endpoint updated successfully.")
        |> redirect(to: Routes.endpoint_path(conn, :show, endpoint))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", endpoint: endpoint, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    endpoint = Repo.get(Endpoint, id)
    {:ok, _endpoint} = Repo.delete(endpoint)

    conn
    |> put_flash(:info, "Endpoint deleted successfully.")
    |> redirect(to: Routes.endpoint_path(conn, :index))
  end
end
