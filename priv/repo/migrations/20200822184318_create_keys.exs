defmodule Gateway.Repo.Migrations.CreateKeys do
  use Ecto.Migration

  def change do
    create table(:keys) do
      add :value, :text, unique: true, null: false
    end

    create unique_index(:keys, [:value])
  end
end
