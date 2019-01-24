defmodule GroupCollect.Report.ReportRowViewTest do
  use GroupCollect.DataCase
  import Ecto.Query

  alias GroupCollect.Report
  alias GroupCollect.Report.ReportRowView
  @csv File.read!("test/fixture_files/passenger_statuses.csv")

  test "should display the denormalized report row" do
    Report.load_from_csv(@csv)

    assert %GroupCollect.Report.ReportRowView{
             birthday: ~D[2006-02-14],
             email: "jeffrustic@gmail.com",
             full_name: "Jeff Rustic",
             gender: "male",
             id: 370,
             package: "Basic Package",
             status: "Fully Paid"
           } = ReportRowView |> order_by([r], asc: r.id) |> limit(1) |> Repo.one()
  end
end
