defmodule GroupCollect.Report.FilterTest do
  @moduledoc """
  All the tests are based on the csv fixture"
  """
  use GroupCollect.DataCase

  alias GroupCollect.Report.Filter
  alias GroupCollect.Report.Import
  alias GroupCollect.Repo

  import Ecto.Query
  @csv File.read!("test/support/fixtures/files/passenger_statuses.csv")

  setup do
    Import.from_csv(@csv)
  end

  test "should filter by genre" do
    male_query = Filter.filter(%{"gender" => "male"})
    female_query = Filter.filter(%{"gender" => "female"})
    assert 6 == Repo.aggregate(male_query, :count, :id)

    assert ["male"] ==
             male_query |> distinct([r], r.gender) |> select([r], r.gender) |> Repo.all()

    assert 12 == Repo.aggregate(female_query, :count, :id)

    assert ["female"] ==
             female_query |> distinct([r], r.gender) |> select([r], r.gender) |> Repo.all()
  end

  test "should filter by age" do
    above18_query = Filter.filter(%{"age" => "above 18"})
    under18_query = Filter.filter(%{"age" => "under 18"})
    assert 4 == Repo.aggregate(above18_query, :count, :id)

    assert [38, 32, 32, 19] ==
             above18_query
             |> select([r], r.birthday)
             |> Repo.all()
             |> Enum.map(&Timex.diff(Timex.today(), &1, :years))

    assert 14 == Repo.aggregate(under18_query, :count, :id)

    assert [13, 13, 12, 13, 13, 12, 13, 13, 13, 12, 12, 12, 13, 12] ==
             under18_query
             |> select([r], r.birthday)
             |> Repo.all()
             |> Enum.map(&Timex.diff(Timex.today(), &1, :years))
  end

  test "should filter by status" do
    ["Fully Paid", "Partially Paid", "Created", "Finished Wizard", "Cancelled"]
    |> Enum.each(fn status ->
      query = Filter.filter(%{"status" => status})
      assert [status] == query |> distinct([r], r.status) |> select([r], r.status) |> Repo.all()
    end)
  end

  test "should filter by package" do
    ["Basic Package", "Presidential Package", "Basic Package", "Basic Package", "Senator Package"]
    |> Enum.each(fn package ->
      query = Filter.filter(%{"package" => package})

      assert [package] ==
               query |> distinct([r], r.package) |> select([r], r.package) |> Repo.all()
    end)
  end
end
