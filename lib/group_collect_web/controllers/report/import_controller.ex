defmodule GroupCollectWeb.Report.ImportController do
  use GroupCollectWeb, :controller
  alias GroupCollect.Report

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def post(conn, %{"csv" => %Plug.Upload{} = csv_upload}) do
    csv_content = File.read!(csv_upload.path)
    require IEx
    IEx.pry()

    with {:ok, _} <- Report.from_csv(csv_content) do
      redirect(conn, to: Routes.report_path(conn, :index))
    end
  end
end
