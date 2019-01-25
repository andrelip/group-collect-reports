defmodule GroupCollect.Repo.Migrations.CreatePassengerLists do
  use Ecto.Migration

  def change do
    create table(:passenger_lists) do
      add :package, :string
      add :status, :string
      add :passenger_id, references(:passengers, on_delete: :nothing)

      timestamps()
    end

    create index(:passenger_lists, [:passenger_id])
  end
end
