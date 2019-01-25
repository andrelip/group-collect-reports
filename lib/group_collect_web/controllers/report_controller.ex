defmodule GroupCollectWeb.ReportController do
  use GroupCollectWeb, :controller
  alias GroupCollect.Report

  def index(conn, params) do
    case Report.has_any_row() do
      false -> redirect(conn, to: Routes.import_path(conn, :new))
      true -> _index(conn, params)
    end
  end

  defp _index(conn, params) do
    passengers = Report.filter_passengers(params)
    render(conn, "index.html", passengers: passengers, params: params)
  end
end
