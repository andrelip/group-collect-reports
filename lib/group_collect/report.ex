defmodule GroupCollect.Report do
  alias GroupCollect.Report.ImportCSV
  alias GroupCollect.Report.ReportLine
  alias GroupCollect.Report.Passenger
  alias GroupCollect.Report.PassengerList
  alias GroupCollect.Repo
  alias Ecto.Multi

  def load_from_csv(data) do
    with {:ok, data} <- ImportCSV.parse(data),
         rows <- map_into_changeset(data),
         {:ok, valid_changesets} <- validate_data(rows) do
      insert_validated_data(valid_changesets)
    end
  end

  defp insert_validated_data(data) do
    data
    |> Enum.each(fn item ->
      item = item |> Map.put_new(:id, item.passenger_id)

      Multi.new()
      |> Multi.insert(:passenger, Passenger.insert_changeset(item))
      |> Multi.insert(:passenger_list, fn %{passenger: passenger} ->
        PassengerList.insert_changeset(passenger, item)
      end)
      |> Repo.transaction()
    end)
  end

  defp map_into_changeset(csv_rows) do
    csv_rows
    |> Enum.map(fn row ->
      row
      |> Map.from_struct()
      |> ReportLine.insert_changeset()
    end)
  end

  defp validate_data(insert_line_changesets) do
    initial_value = [valid: [], invalid: []]

    splited_data_by_validation =
      insert_line_changesets
      |> Enum.reduce(initial_value, fn changeset, acc ->
        case changeset.valid? do
          true -> [valid: [changeset | acc[:valid]], invalid: acc[:invalid]]
          false -> [valid: acc[:valid], invalid: [changeset | acc[:invalid]]]
        end
      end)

    case splited_data_by_validation[:invalid] == [] do
      true ->
        {:ok, splited_data_by_validation[:valid] |> Enum.map(fn x -> x.changes end)}

      false ->
        {:error, [changeset_with_errors: splited_data_by_validation[:invalid]]}
    end
  end
end
