defmodule GroupCollect.Report do
  @moduledoc """
  Public API for the Report bounded context.
  """
  alias GroupCollect.Repo
  alias GroupCollect.Report.Import
  alias GroupCollect.Report.ReportRowView

  @doc """
  Receives the content of a CSV file and tries to insert the data into
  the proper tables.
  """
  @spec from_csv(binary()) ::
          {:ok, %{optional(Import.multi_operation_key()) => Import.passenger()}}
          | {:error, any()}
  defdelegate from_csv(data), to: Import

  def all do
    Repo.all(ReportRowView)
  end
end
