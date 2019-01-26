defmodule GroupCollect.Analyze do
  import Ecto.Query

  alias GroupCollect.Repo
  alias GroupCollect.Report.ReportRowView

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

  def summarize_by_package_for_paid_passengers(include_wizard: wizard) do
    case wizard do
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
