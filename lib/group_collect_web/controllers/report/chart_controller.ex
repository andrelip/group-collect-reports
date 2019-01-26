defmodule GroupCollectWeb.Report.ChartController do
  use GroupCollectWeb, :controller
  alias GroupCollect.Report.Analyze
  plug :put_layout, "report.html"

  def package(conn, _params) do
    {graph_labels, graph_values} =
      Analyze.summarize_by_package_for_paid_passengers(include_wizard: false) |> Enum.unzip()

    render(conn, "package.html", graph_labels: graph_labels, graph_values: graph_values)
  end
end
