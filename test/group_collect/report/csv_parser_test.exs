defmodule GroupCollect.Report.CSVParserTest do
  use GroupCollect.DataCase

  alias GroupCollect.Report.CSVParser
  alias GroupCollect.Report.ReportRow

  @valid_comma_csv "Passenger ID,Full Name,Gender,Email,Package,Date of Birth,Status\n370,Jeff Rustic,male,jeffrustic@gmail.com,Basic Package,2006-02-14,Fully Paid"
  @valid_out_or_order_comma_csv "Full Name,Passenger ID,Gender,Email,Package,Date of Birth,Status\nJeff Rustic,370,male,jeffrustic@gmail.com,Basic Package,2006-02-14,Fully Paid"
  @invalid_comma_csv "Passenger ID,Full Name\n"
  @tabulated_csv "Passenger ID\tFull Name\tGender\tEmail\tPackage\tDate of Birth\tStatus"

  describe "CommaCSV" do
    test "validate_header/1 should return true when csv have all the valid values" do
      assert true == CSVParser.validate_header(@valid_comma_csv)
    end

    test "validate_header/1 should return false for missing keys" do
      assert false == CSVParser.validate_header(@invalid_comma_csv)
    end

    test "parse_valid/1 should convert the csv a map no matter the order" do
      right_map = [
        %ReportRow{
          :birthday => "2006-02-14",
          :email => "jeffrustic@gmail.com",
          :full_name => "Jeff Rustic",
          :gender => "male",
          :package => "Basic Package",
          :passenger_id => "370",
          :status => "Fully Paid"
        }
      ]

      assert {:ok, right_map} == CSVParser.parse(@valid_comma_csv)
      assert {:ok, right_map} == CSVParser.parse(@valid_out_or_order_comma_csv)
      assert {:error, _} = CSVParser.parse(@invalid_comma_csv)
      assert {:error, _} = CSVParser.parse(@tabulated_csv)
    end
  end

  test "format_map/1 should convert the csv row into report row struct" do
    input = %{
      "Date of Birth" => "2006-02-14",
      "Email" => "jeffrustic@gmail.com",
      "Full Name" => "Jeff Rustic",
      "Gender" => "male",
      "Package" => "Basic Package",
      "Passenger ID" => "370",
      "Status" => "Fully Paid"
    }

    output = %ReportRow{
      :birthday => "2006-02-14",
      :email => "jeffrustic@gmail.com",
      :full_name => "Jeff Rustic",
      :gender => "male",
      :package => "Basic Package",
      :passenger_id => "370",
      :status => "Fully Paid"
    }

    assert output == input |> CSVParser.format_map()
  end
end
