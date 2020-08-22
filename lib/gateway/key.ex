defmodule Gateway.Key do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keys" do
    field :value, :string
    timestamps()
  end

  @required_attributes ~w(value)a

  def changeset(key, params) do
    key
    |> cast(params, @required_attributes)
    |> set_api_key_value_if_empty()
    |> validate_required(@required_attributes)
    |> unique_constraint(:value)
  end

  defp set_api_key_value_if_empty(ch) do
    case get_change(ch, :value) do
      nil -> put_change(ch, :value, generate_key())
      "" -> put_change(ch, :value, generate_key())
      _ -> ch
    end
  end

  defp generate_key do
    Ecto.UUID.generate() |> ShortUUID.encode!()
  end
end
