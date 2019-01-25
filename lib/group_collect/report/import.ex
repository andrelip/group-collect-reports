defmodule GroupCollect.Report.Import do
  @moduledoc """
  Acts like a gateway that receives data from different sources and
  adds to the domain and database.
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
  @spec from_csv(binary()) ::
          {:ok, %{optional(multi_operation_key) => passenger}} | {:error, any()}
  def from_csv(csv_content) do
    with {:ok, data} <- CSVParser.parse(csv_content) do
      load(data)
    end
  end

  defp load(data) do
    with items <- map_into_changeset(data),
         {:ok, valid_changesets} <- validate_data(items) do
      insert_validated_data(valid_changesets)
    end
  end

  defp insert_validated_data(data) do
    {multi, _} =
      data
      |> Enum.reduce({Multi.new(), 1}, &_reduce_multi_operations/2)

    case Repo.transaction(multi) do
      {:error, _, changeset, _} -> {:error, changeset}
      any -> any
    end
  end

  defp _reduce_multi_operations(item, {multi, idx} = _acc) do
    item = item |> Map.put_new(:id, item.passenger_id)

    passenger_transaction_id = {:passenger, idx}
    passenger_list_transaction_id = {:passenger_list, idx}

    multi =
      multi
      |> Multi.insert(passenger_transaction_id, PassengerSchema.insert_changeset(item))
      |> Multi.insert(passenger_list_transaction_id, fn %{
                                                          ^passenger_transaction_id => passenger
                                                        } ->
        PassengerListSchema.insert_changeset(passenger, item)
      end)

    {multi, idx + 1}
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
