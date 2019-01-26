defmodule GroupCollect.Report.Analyze do
  @moduledoc """
  Compiles analysis of different report templates
  """
  import Ecto.Query

  alias GroupCollect.Repo
  alias GroupCollect.Report.ReportRowView

  @doc """
  Group and count by statuses using all the passengers as source
  """
  def summarize_by_statuses do
    from(r in ReportRowView,
      group_by: r.status,
      select: {
        r.status,
        count(r.status)
      }
    )
    |> Repo.all()
    |> Enum.into(%{})
  end

  @doc """
  Group and count by statuses using all the scoped filter of passengers
  as source
  """
  def summarize_by_statuses(filter) do
    from(r in filter,
      group_by: r.status,
      select: {
        r.status,
        count(r.status)
      }
    )
    |> Repo.all()
    |> Enum.into(%{})
  end

  @doc """
  Group and count packages of users that paid or partially paid.

  opts:
  include_wizard -> also counts the users that completed the wizard
  """
  def summarize_by_package_for_paid_passengers(params \\ []) do
    case params[:include_wizard] do
      false ->
        from(r in ReportRowView,
          where: r.status == "Fully Paid" or r.status == "Partially Paid",
          group_by: r.package,
          select: {
            r.package,
            count(r.package)
          }
        )

      true ->
        from(r in ReportRowView,
          where:
            r.status == "Fully Paid" or r.status == "Partially Paid" or
              r.status == "Finished Wizard",
          group_by: r.package,
          select: {
            r.package,
            count(r.package)
          }
        )
    end
    |> Repo.all()
    |> Enum.into(%{})
  end
end
