defmodule Gateway.Repo.Migrations.CreateKeys do
  use Ecto.Migration

  def change do
    create table(:keys, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :value, :text, unique: true, null: false
      timestamps()
    end

    create unique_index(:keys, [:value])
  end
end
