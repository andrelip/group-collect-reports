defmodule GroupCollectWeb.Report.MessageController do
  use GroupCollectWeb, :controller
  alias GroupCollect.Report
  alias GroupCollect.Report.Messaging
  alias GroupCollect.Report.Gate.Message
  plug :put_layout, "report.html"

  def new(conn, params) do
    changeset = Report.change_message(%Message{})
    render(conn, "new.html", changeset: changeset, params: params)
  end

  def create(conn, %{"message" => message_params} = params) do
    case Report.verify_message(message_params) do
      {:ok, message} ->
        _create(conn, message, params)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset |> Map.put(:action, :insert), params: params)
    end
  end

  defp _create(conn, %Message{} = gate_message, params) do
    filter_query = Report.filter_passengers_query(params)

    messaging_dto = %Messaging{
      media: gate_message.media,
      subject: gate_message.subject,
      body: gate_message.body
    }

    Messaging.send_batch(filter_query, messaging_dto)

    conn
    |> put_flash(:success, "Message delivered")
    |> redirect(to: Routes.report_path(conn, :index))
  end
end
