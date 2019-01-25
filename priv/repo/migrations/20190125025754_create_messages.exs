defmodule GroupCollect.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :subject, :string
      add :body, :text
      add :passenger_id, references(:passengers, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:passenger_id])
  end
end
