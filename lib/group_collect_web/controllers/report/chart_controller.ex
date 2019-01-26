defmodule GroupCollectWeb.Report.ChartController do
  use GroupCollectWeb, :controller
  alias GroupCollect.Report.Analyze
  plug :put_layout, "report.html"

  def package(conn, params) do
    include_wizard = params["include_wizard"] == "true"
    IO.inspect(include_wizard)

    {graph_labels, graph_values} =
      Analyze.summarize_by_package_for_paid_passengers(include_wizard: include_wizard)
      |> Enum.unzip()

    render(conn, "package.html",
      params: params,
      graph_labels: graph_labels,
      graph_values: graph_values
    )
  end
end
