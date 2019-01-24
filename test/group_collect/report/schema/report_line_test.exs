defmodule GroupCollect.Report.ReportLineTest do
  use GroupCollect.DataCase

  alias GroupCollect.Report.ReportLine

  @valid_attrs %{
    :birthday => "2006-02-14",
    :email => "jeffrustic@gmail.com",
    :full_name => "Jeff Rustic",
    :gender => "male",
    :package => "Basic Package",
    :passenger_id => "370",
    :status => "Fully Paid"
  }

  describe "insert_changeset/1" do
    test "should create user with valid attrs" do
      assert true == @valid_attrs |> ReportLine.insert_changeset() |> Map.get(:valid?)
      assert false == %{} |> ReportLine.insert_changeset() |> Map.get(:valid?)
    end

    test "should validate gender" do
      ["male", "female", "other", "prefer not to say"]
      |> Enum.each(fn valid_gender ->
        assert true ==
                 %{@valid_attrs | gender: valid_gender}
                 |> ReportLine.insert_changeset()
                 |> Map.get(:valid?)
      end)

      assert false ==
               %{@valid_attrs | gender: "invalid gender"}
               |> ReportLine.insert_changeset()
               |> Map.get(:valid?)
    end

    test "birthday should be a past date" do
      assert true ==
               %{@valid_attrs | birthday: Timex.today() |> Timex.shift(days: -1)}
               |> ReportLine.insert_changeset()
               |> Map.get(:valid?)

      assert false ==
               %{@valid_attrs | birthday: Timex.today() |> Timex.shift(days: 1)}
               |> ReportLine.insert_changeset()
               |> Map.get(:valid?)
    end
  end
end
