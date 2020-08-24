defmodule Gateway.Repo.Migrations.CreateEndpoints do
  use Ecto.Migration

  def change do
    create table(:endpoints, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :path, :text, unique: true, null: false
      add :upstream, :text, null: false
      timestamps()
    end

    create unique_index(:endpoints, [:path])
  end
end
