defmodule GroupCollect.ReportTest do
  use GroupCollect.DataCase
  alias GroupCollect.Report.Passenger
  alias GroupCollect.Report.PassengerList
  alias GroupCollect.Repo

  alias GroupCollect.Report
  @csv File.read!("test/fixture_files/passenger_statuses.csv")

  describe "load_from_csv/1" do
    test "should save into database" do
      assert :ok == Report.load_from_csv(@csv)
    end

    test "should create passengers" do
      csv_rows = String.split(@csv, "\n")
      csv_rows_count = length(csv_rows) - 1
      assert :ok == Report.load_from_csv(@csv)
      assert csv_rows_count == Repo.aggregate(Passenger, :count, :id)
      first_passenger = from(p in Passenger, order_by: [asc: :id], limit: 1) |> Repo.one()

      assert %GroupCollect.Report.Passenger{
               birthday: ~D[2006-02-14],
               email: "jeffrustic@gmail.com",
               full_name: "Jeff Rustic",
               gender: "male",
               id: 370
             } = first_passenger
    end

    test "should insert passenger into the respective list" do
      Report.load_from_csv(@csv)
      csv_rows = String.split(@csv, "\n")
      csv_rows_count = length(csv_rows) - 1

      assert csv_rows_count ==
               from(p in Passenger,
                 join: pl in PassengerList,
                 on: pl.passenger_id == p.id,
                 select: count(pl.id)
               )
               |> Repo.one()

      first_passenger_list_row =
        from(p in PassengerList, order_by: [asc: :passenger_id], limit: 1) |> Repo.one()

      assert %GroupCollect.Report.PassengerList{
               package: "Basic Package",
               passenger_id: 370,
               status: "Fully Paid"
             } = first_passenger_list_row
    end
  end
end
