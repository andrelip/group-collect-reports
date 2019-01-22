defmodule GroupCollect.Repo.Migrations.CreateReportLines do
  use Ecto.Migration

  def change do
    create table(:report_lines) do
      add :passenger_id, :integer
      add :full_name, :string
      add :gender, :string
      add :email, :string
      add :package, :string
      add :birthday, :date
      add :status, :string

      timestamps()
    end

    create index("report_lines", [:passenger_id])
    create index("report_lines", [:gender])
    create index("report_lines", [:package])
    create index("report_lines", [:status])
  end
end
