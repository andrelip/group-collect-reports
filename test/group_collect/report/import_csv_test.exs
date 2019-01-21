defmodule GroupCollect.Report.ImportCSVTest do
  use GroupCollect.DataCase

  alias GroupCollect.Report.ImportCSV

  @valid_comma_csv "Passenger ID,Full Name,Gender,Email,Package,Date of Birth,Status\n370,Jeff Rustic,male,jeffrustic@gmail.com,Basic Package,2006-02-14,Fully Paid"
  @valid_out_or_order_comma_csv "Full Name,Passenger ID,Gender,Email,Package,Date of Birth,Status\nJeff Rustic,370,male,jeffrustic@gmail.com,Basic Package,2006-02-14,Fully Paid"
  @invalid_comma_csv "Passenger ID,Full Name\n"
  @tabulated_csv "Passenger ID\tFull Name\tGender\tEmail\tPackage\tDate of Birth\tStatus"

  describe "CommaCSV" do
    test "validate_header/1 should return true for right values" do
      assert true == ImportCSV.validate_header(@valid_comma_csv)
    end

    test "validate_header/1 should return false for wrong header keys" do
      assert false == ImportCSV.validate_header(@invalid_comma_csv)
    end

    test "parse/1 should convert to map no matter the order" do
      right_map = [
        %{
          "Date of Birth" => "2006-02-14",
          "Email" => "jeffrustic@gmail.com",
          "Full Name" => "Jeff Rustic",
          "Gender" => "male",
          "Package" => "Basic Package",
          "Passenger ID" => "370",
          "Status" => "Fully Paid"
        }
      ]

      assert right_map == ImportCSV.parse(@valid_comma_csv)
      assert right_map == ImportCSV.parse(@valid_out_or_order_comma_csv)
    end
  end
end
