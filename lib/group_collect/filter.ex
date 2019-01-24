defmodule GroupCollect.Report.Filter do
  @moduledoc """
  API for filtering the report list
  """

  import Ecto.Query

  alias GroupCollect.Report.ReportRowView

  def filter(params) do
    params
    |> reduce_apply_filters(ReportRowView)
  end

  defp reduce_apply_filters(params, query) do
    params
    |> Map.to_list()
    |> Enum.reduce(query, fn x, query_acc ->
      apply_filter(query_acc, x)
    end)
  end

  defp apply_filter(query, {:gender, gender}) do
    query |> where([p], p.gender == ^gender)
  end

  defp apply_filter(query, {:package, package}) do
    query |> where([p], p.package == ^package)
  end

  defp apply_filter(query, {:status, status}) do
    query |> where([p], p.status == ^status)
  end

  defp apply_filter(query, {:age, "above 18"}) do
    start_date = Timex.now() |> Timex.shift(years: -18)
    query |> where([p], p.birthday <= ^start_date)
  end

  defp apply_filter(query, {:age, "under 18"}) do
    start_date = Timex.now() |> Timex.shift(years: -18)
    query |> where([p], p.birthday > ^start_date)
  end

  defp apply_filter(query, {:age, _}), do: query
end
