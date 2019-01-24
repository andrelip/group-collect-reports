defmodule GroupCollect.Report.ImportFromCSVTest do
  use GroupCollect.DataCase
  alias GroupCollect.Report.PassengerSchema
  alias GroupCollect.Report.PassengerListSchema
  alias GroupCollect.Repo

  alias GroupCollect.Report.Import
  @csv File.read!("test/support/fixtures/files/passenger_statuses.csv")
  @csv_with_duplicated_entries File.read!(
                                 "test/support/fixtures/files/passenger_with_duplicated_id.csv"
                               )

  describe "from_csv/1" do
    test "should create passengers" do
      csv_rows = String.split(@csv, "\n")
      csv_rows_count = length(csv_rows) - 1
      assert {:ok, _} = Import.from_csv(@csv)
      assert csv_rows_count == Repo.aggregate(PassengerSchema, :count, :id)
      first_passenger = from(p in PassengerSchema, order_by: [asc: :id], limit: 1) |> Repo.one()

      assert %GroupCollect.Report.PassengerSchema{
               birthday: ~D[2006-02-14],
               email: "jeffrustic@gmail.com",
               full_name: "Jeff Rustic",
               gender: "male",
               id: 370
             } = first_passenger
    end

    test "should raise an error for duplicated passengers" do
      assert {:error, changeset} = Import.from_csv(@csv_with_duplicated_entries)

      assert changeset.errors == [
               id:
                 {"has already been taken",
                  [constraint: :unique, constraint_name: "passengers_pkey"]}
             ]

      assert 0 == Repo.aggregate(PassengerSchema, :count, :id)
    end

    test "should insert passenger into the respective list" do
      Import.from_csv(@csv)
      csv_rows = String.split(@csv, "\n")
      csv_rows_count = length(csv_rows) - 1

      assert csv_rows_count ==
               from(p in PassengerSchema,
                 join: pl in PassengerListSchema,
                 on: pl.passenger_id == p.id,
                 select: count(pl.id)
               )
               |> Repo.one()

      first_passenger_list_row =
        from(p in PassengerListSchema, order_by: [asc: :passenger_id], limit: 1) |> Repo.one()

      assert %GroupCollect.Report.PassengerListSchema{
               package: "Basic Package",
               passenger_id: 370,
               status: "Fully Paid"
             } = first_passenger_list_row
    end
  end
end
