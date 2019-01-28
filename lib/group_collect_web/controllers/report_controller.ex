defmodule GroupCollectWeb.ReportController do
  use GroupCollectWeb, :controller
  alias GroupCollect.Report
  alias GroupCollect.Report.Analyze
  plug :put_layout, "report.html"

  def index(conn, params) do
    case Report.has_any_row() do
      false -> redirect(conn, to: Routes.import_path(conn, :new))
      true -> _index(conn, params)
    end
  end

  defp _index(conn, params) do
    passengers = Report.filter_passengers(params)
    passengers_query = Report.filter_passengers_query(params)
    packages = Report.all_existing_packages()

    {graph_labels, graph_values} =
      passengers_query |> Analyze.summarize_by_statuses() |> Map.from_struct() |> Enum.unzip()

    render(conn, "index.html",
      params: params,
      passengers: passengers,
      packages: packages,
      graph_labels: Poison.encode!(graph_labels),
      graph_values: Poison.encode!(graph_values)
    )
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => passenger_id}) do
    with {:ok, passenger} <- Report.get_passenger(passenger_id),
         messages <- Report.get_messages(passenger.id) do
      render(conn, "show.html", passenger: passenger, messages: messages)
    else
      {:error, :passenger_not_found} ->
        conn
        |> put_flash(:error, "Passenger not found")
        |> redirect(to: Routes.report_path(conn, :index))
    end
  end
end
