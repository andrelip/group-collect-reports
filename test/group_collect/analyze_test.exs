defmodule GroupCollect.AnalyzeTest do
  @moduledoc """
  All the tests are based on the csv fixture"
  """
  use GroupCollect.DataCase

  alias GroupCollect.Analyze
  alias GroupCollect.Report.Import

  @csv File.read!("test/support/fixtures/files/passenger_statuses.csv")

  setup do
    Import.from_csv(@csv)
  end

  test "summarize_by_statuses/1 should display grouped data with proper count" do
    assert %{
             "Cancelled" => 2,
             "Created" => 3,
             "Finished Wizard" => 4,
             "Fully Paid" => 3,
             "Partially Paid" => 6
           } = Analyze.summarize_by_statuses()
  end

  test "summarize_by_package_for_paid_passengers/1 should display grouped data with proper count" do
    assert %{
             "Basic Package" => 2,
             "Presidential Package" => 3,
             "Senator Package" => 4
           } = Analyze.summarize_by_package_for_paid_passengers(include_wizard: false)

    assert %{
             "Basic Package" => 3,
             "Presidential Package" => 4,
             "Senator Package" => 6
           } = Analyze.summarize_by_package_for_paid_passengers(include_wizard: true)
  end
end
