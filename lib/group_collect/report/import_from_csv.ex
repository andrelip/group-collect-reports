defmodule GroupCollect.Report.ImportFromCSV do
  @moduledoc """
  Handles to data load from the standard CSV model
  """
  alias GroupCollect.Report.CSVParser
  alias GroupCollect.Report.ReportLine
  alias GroupCollect.Report.PassengerSchema
  alias GroupCollect.Report.PassengerListSchema
  alias GroupCollect.Repo
  alias Ecto.Multi

  @type multi_operation_key :: {:passenger | :passenger_list, integer()}
  @type passenger :: %PassengerSchema{}

  @doc """
  Receives the content of a CSV file and tries to insert the data into
  the proper tables.
  """
  @spec load_from_csv(binary()) ::
          {:ok, %{optional(multi_operation_key) => passenger}} | {:error, any()}
  def load_from_csv(data) do
    with {:ok, data} <- CSVParser.parse(data),
         rows <- map_into_changeset(data),
         {:ok, valid_changesets} <- validate_data(rows) do
      insert_validated_data(valid_changesets)
    end
  end

  defp insert_validated_data(data) do
    {multi, _} =
      data
      |> Enum.reduce({Multi.new(), 1}, fn item, {multi, idx} ->
        item = item |> Map.put_new(:id, item.passenger_id)

        passenger_transaction_id = {:passenger, idx}
        passenger_list_transaction_id = {:passenger_list, idx}

        multi =
          multi
          |> Multi.insert(passenger_transaction_id, PassengerSchema.insert_changeset(item))
          |> Multi.insert(passenger_list_transaction_id, fn %{
                                                              ^passenger_transaction_id =>
                                                                passenger
                                                            } ->
            PassengerListSchema.insert_changeset(passenger, item)
          end)

        {multi, idx + 1}
      end)

    case Repo.transaction(multi) do
      {:error, _, changeset, _} -> {:error, changeset}
      any -> any
    end
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
