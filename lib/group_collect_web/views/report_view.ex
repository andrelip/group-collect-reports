defmodule GroupCollectWeb.ReportView do
  use GroupCollectWeb, :view

  def format_date(date) do
    Timex.format!(date, "%m-%d-%Y", :strftime)
  end

  def gender(passenger) do
    String.capitalize(passenger.gender)
  end

  def add_filter(conn, params, key, gender) do
    Routes.report_path(conn, :index, Map.put(params, key, gender))
  end

  def remove_filter(conn, params, key) do
    Routes.report_path(conn, :index, Map.delete(params, key))
  end

  def show_active_tag(conn, params, key, desired_value) do
    case params[key] do
      nil ->
        nil

      value ->
        if value == desired_value do
          "active"
        end
    end
  end
end
