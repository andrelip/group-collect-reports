defmodule GroupCollect.Report do
  @moduledoc """
  Public API for the Report bounded context.
  """
  alias GroupCollect.Report.ImportFromCSV

  @doc """
  Receives the content of a CSV file and tries to insert the data into
  the proper tables.
  """
  @spec load_from_csv(binary()) ::
          {:ok, %{optional(ImportFromCSV.multi_operation_key()) => ImportFromCSV.passenger()}}
          | {:error, any()}
  defdelegate load_from_csv(data), to: ImportFromCSV
end
