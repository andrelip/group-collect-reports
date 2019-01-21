defmodule GroupCollect.Report.ImportCSV do
  @moduledoc """
  Parse the GroupCollect CSV containing the status of many passengers.

  The CSV should be formated as RFC4180 standards and should have the following columns:

  Passenger ID | Full Name | Gender | Email | Package | Date of Birth | Status
  """

  alias NimbleCSV.RFC4180, as: CSV

  @header_keys [
    "Passenger ID",
    "Full Name",
    "Gender",
    "Email",
    "Package",
    "Date of Birth",
    "Status"
  ]

  @type csv_content :: binary()
  @type t :: %{
          "Passenger ID": String.t(),
          "Full Name": String.t(),
          Gender: String.t(),
          Email: String.t(),
          Package: String.t(),
          "Date of Birth": String.t(),
          Status: String.t()
        }

  @doc """
  Verifies if the csv are well formated and contains all the required columns
  """
  @spec validate_header(csv_content()) :: boolean()
  def validate_header(string) do
    [header | _] = parse_raw(string)

    case validate_header_keys(header) do
      true -> true
      false -> false
    end
  end

  @doc """
  Receives the csv string and tries to parse into a map
  """
  @spec parse(csv_content()) ::
          {:error, %{msg: binary(), required: [binary(), ...]}} | {:ok, [t(), ...]}
  def parse(string) do
    case validate_header(string) do
      true -> {:ok, parse_valid(string)}
      false -> {:error, %{msg: "missing_required_keys", required: @header_keys}}
    end
  end

  defp parse_raw(string) do
    CSV.parse_string(string, headers: false)
  end

  defp parse_valid(string) do
    [header | body] =
      string
      |> parse_raw

    body
    |> Enum.map(fn row ->
      header
      |> Enum.zip(row)
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
