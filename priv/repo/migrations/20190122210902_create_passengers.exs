defmodule GroupCollect.Repo.Migrations.CreatePassengers do
  use Ecto.Migration

  def change do
    create table(:passengers) do
      add :id, :integer
      add :full_name, :string
      add :gender, :string
      add :email, :string
      add :birthday, :date

      timestamps()
    end

  end
end
