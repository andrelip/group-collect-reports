defmodule GroupCollectWeb.ReportController do
  use GroupCollectWeb, :controller
  alias GroupCollect.Report

  def index(conn, params) do
    case Report.all() do
      [] -> redirect(conn, to: Routes.import_path(conn, :new))
      passengers -> _index(conn, passengers, params)
    end
  end

  defp _index(conn, passengers, params) do
    render(conn, "index.html", passengers: passengers)
  end
end
