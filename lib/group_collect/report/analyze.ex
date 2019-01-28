defmodule GroupCollect.Report.Analyze do
  @moduledoc """
  Compiles analysis of different report templates
  """
  import Ecto.Query

  alias GroupCollect.Repo
  alias GroupCollect.Report.ReportRowView
  alias GroupCollect.Report.Analyzer.PackageChart
  alias GroupCollect.Report.Analyzer.StatusChart

  @doc """
  Group and count by statuses using all the passengers as source
  """
  def summarize_by_statuses do
    struct_params =
      from(r in ReportRowView,
        group_by: r.status,
        select: {
          r.status,
          count(r.status)
        }
      )
      |> Repo.all()
      |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
      |> Enum.into(%{})

    struct(%StatusChart{}, struct_params)
  end

  @doc """
  Group and count by statuses using all the scoped filter of passengers
  as source
  """
  def summarize_by_statuses(filter) do
    struct_params =
      from(r in filter,
        group_by: r.status,
        select: {
          r.status,
          count(r.status)
        }
      )
      |> Repo.all()
      |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
      |> Enum.into(%{})

    struct(%StatusChart{}, struct_params)
  end

  @doc """
  Group and count packages of users that paid or partially paid.

  opts:
  include_wizard -> also counts the users that completed the wizard
  """
  def summarize_by_package_for_paid_passengers(params \\ []) do
    struct_params =
      ReportRowView
      |> filter_by_paid_status(params[:include_wizard])
      |> group_by([r], r.package)
      |> select([r], {r.package, count(r.package)})
      |> Repo.all()
      |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
      |> Enum.into(%{})

    struct(%PackageChart{}, struct_params)
  end

  defp filter_by_paid_status(query, include_wizard) do
    case include_wizard do
      true ->
        query
        |> where(
          [r],
          r.status == "Fully Paid" or r.status == "Partially Paid" or
            r.status == "Finished Wizard"
        )

      false ->
        query
        |> where([r], r.status == "Fully Paid" or r.status == "Partially Paid")
    end
  end
end
