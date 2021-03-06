defmodule GroupCollect.Repo.Migrations.CreateReportView do
  use Ecto.Migration
  import Ecto.Query
  alias GroupCollect.DBView
  alias GroupCollect.Report.PassengerSchema
  alias GroupCollect.Report.PassengerListSchema

  def up do
    query =
      from(p in PassengerSchema,
        join: pl in PassengerListSchema,
        on: pl.passenger_id == p.id,
        select: %{
          passenger_id: p.id,
          full_name: p.full_name,
          email: p.email,
          gender: p.gender,
          birthday: p.birthday,
          package: pl.package,
          status: pl.status
        }
      )

    GroupCollect.DBView.create_view_from_query(query, "report_rows")
  end

  def down do
    DBView.drop_view("report_rows")
  end
end
