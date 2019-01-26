defmodule GroupCollectWeb.Report.ImportController do
  use GroupCollectWeb, :controller
  alias GroupCollect.Report
  plug :put_layout, "report.html"

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def post(conn, %{"csv" => %Plug.Upload{} = csv_upload}) do
    csv_content = File.read!(csv_upload.path)

    with {:ok, _} <- Report.from_csv(csv_content) do
      redirect(conn, to: Routes.report_path(conn, :index))
    else
      {:error, %{duplicated_entries: entries}} ->
        conn
        |> put_flash(
          :error,
          "Error loading csv because it have duplicated entries: #{Enum.join(entries, ", ")}. You can upload existing ids but you cannot have duplicated entries at the same csv."
        )
        |> render("new.html")

      {:error, %{msg: "missing_required_keys", missing: missing}} ->
        conn
        |> put_flash(
          :error,
          "Error loading csv because it is malformed or lacking required columns. Missing keys: #{
            missing |> Enum.join(", ")
          }"
        )
        |> render("new.html")
    end
  end
end
