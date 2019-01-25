defmodule GroupCollect.Report do
  @moduledoc """
  Public API for the Report bounded context.
  """
  alias GroupCollect.Repo
  alias GroupCollect.Report.Import
  alias GroupCollect.Report.Filter
  alias GroupCollect.Report.ReportRowView

  import Ecto.Query

  @doc """
  Receives the content of a CSV file and tries to insert the data into
  the proper tables.
  """
  @spec from_csv(binary()) ::
          {:ok, %{optional(Import.multi_operation_key()) => Import.passenger()}}
          | {:error, any()}
  defdelegate from_csv(data), to: Import

  def has_any_row do
    case from(r in ReportRowView, limit: 1, select: r.id) |> Repo.one() do
      nil -> false
      _ -> true
    end
  end

  def all do
    Repo.all(ReportRowView)
  end

  def filter_passengers(params) do
    Filter.filter(params)
    |> Repo.all()
  end

  def all_existing_packages() do
    from(p in ReportRowView, order_by: [asc: p.package], distinct: p.package, select: p.package)
    |> Repo.all()
  end
end
