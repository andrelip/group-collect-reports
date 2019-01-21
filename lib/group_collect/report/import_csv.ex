NimbleCSV.define(CommaCSVParser, separator: ",", escape: "\"")

defmodule GroupCollect.Report.ImportCSV do
  @header_keys [
    "Passenger ID",
    "Full Name",
    "Gender",
    "Email",
    "Package",
    "Date of Birth",
    "Status"
  ]
  def validate_header(string) do
    [header | _] = CommaCSVParser.parse_string(string, headers: false)

    case validate_header_keys(header) do
      true -> true
      false -> false
    end
  end

  # def parse(string) do
  #   case validate_header(string) do
  #     false -> {:error, :invalid_headers}
  #     true ->
  #       string
  #       |> CommaCSVParser.parse_string(headers: false)

  #   end
  # end

  def parse(string) do
    [header | body] =
      string
      |> CommaCSVParser.parse_string(headers: false)

    body
    |> Enum.map(fn row ->
      Enum.zip(header, row)
      |> Enum.into(%{})
    end)
  end

  defp validate_header_keys(header) do
    have_invalid_key =
      @header_keys
      |> Enum.map(&Enum.member?(header, &1))
      |> Enum.member?(false)

    !have_invalid_key
  end
end
