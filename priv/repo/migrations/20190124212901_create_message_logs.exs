defmodule GroupCollect.Repo.Migrations.CreateMessageLogs do
  use Ecto.Migration

  def change do
    create table(:message_logs) do
      add :passenger, :string
      add :subject, :string
      add :body, :text
      add :media, :string
      add :passenger_id, references(:passengers, on_delete: :nothing)

      timestamps()
    end

    create index(:message_logs, [:passenger_id])
    create index(:message_logs, [:subject])
    create index(:message_logs, [:media])
  end
end
