defmodule Gateway.Endpoint do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "endpoints" do
    field :path, :string
    field :upstream, :string
    timestamps()
  end

  @required_attributes ~w(path upstream)a

  @doc false
  def changeset(key, params) do
    key
    |> cast(params, @required_attributes)
    |> validate_required(@required_attributes)
    |> unique_constraint(:path)
  end
end
