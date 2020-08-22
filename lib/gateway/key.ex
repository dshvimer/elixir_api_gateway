defmodule Gateway.Key do
  use Ecto.Schema

  schema "keys" do
    field :value, :string
    timestamps()
  end

  @required_attributes ~w(value)

  def changeset(key, params) do
    key
    |> cast(params, @required_attributes)
    |> validate_required(@required_attributes)
    |> unique_constraint(:value)
  end
end
