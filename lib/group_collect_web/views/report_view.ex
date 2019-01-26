defmodule GroupCollectWeb.ReportView do
  use GroupCollectWeb, :view

  def format_date(date) do
    Timex.format!(date, "%m/%d/%Y", :strftime)
  end

  def format_time(date) do
    Timex.format!(date, "%a, %e %b %Y %H:%M", :strftime)
  end

  def gender(passenger) do
    String.capitalize(passenger.gender)
  end

  def capitalize(text) do
    String.capitalize(text)
  end

  def add_filter(conn, params, key, gender) do
    Routes.report_path(conn, :index, Map.put(params, key, gender))
  end

  def remove_filter(conn, params, key) do
    Routes.report_path(conn, :index, Map.delete(params, key))
  end

  def show_active_tag(params, key, desired_value) do
    case params[key] do
      nil ->
        nil

      value ->
        if value == desired_value do
          "active"
        end
    end
  end

  def status(passenger) do
    case passenger.status do
      "Fully Paid" ->
        "<span class=\"badge badge-pill badge-success\" style=\"margin-right: 10px;\">Fully Paid</span>"

      "Partially Paid" ->
        "<span class=\"badge badge-pill badge-success\" style=\"margin-right: 10px;\">Partially Paid</span>"

      "Created" ->
        "<span class=\"badge badge-pill badge-success\" style=\"margin-right: 10px;\">Created</span>"

      "Finished Wizard" ->
        "<span class=\"badge badge-pill badge-success\" style=\"margin-right: 10px;\">Finished Wizard</span>"

      "Cancelled" ->
        "<span class=\"badge badge-pill badge-success\" style=\"margin-right: 10px;\">Cancelled</span>"
    end
  end

  def media(passenger) do
    case passenger.media do
      "email" ->
        "<span class=\"badge badge-pill badge-light\" style=\"margin-right: 10px;\">Email</span>"

      "internal_message" ->
        "<span class=\"badge badge-pill badge-dark\" style=\"margin-right: 10px;\">Internal Message</span>"
    end
  end

  def render_redirect_message(conn, passenger) do
    passenger_id = passenger.id

    link("Send message",
      to: Routes.message_path(conn, :new, %{"passenger_id" => passenger_id}),
      class: "btn btn-primary btn-lg"
    )
  end
end
