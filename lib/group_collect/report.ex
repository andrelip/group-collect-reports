defmodule GroupCollect.Report do
  @moduledoc """
  Public API for the Report bounded context.
  """
  alias Ecto.Changeset
  alias GroupCollect.Repo
  alias GroupCollect.Report.Import
  alias GroupCollect.Report.Filter
  alias GroupCollect.Report.ReportRowView
  alias GroupCollect.Report.MessageLogSchema
  alias GroupCollect.Report.Gate.Message

  import Ecto.Query

  @doc """
  Receives the content of a CSV file and tries to insert the data into
  the proper tables.
  """
  @spec from_csv(binary()) ::
          {:ok, %{optional(Import.multi_operation_key()) => Import.passenger()}}
          | {:error, any()}
  defdelegate from_csv(data), to: Import

  def has_any_row do
    case from(r in ReportRowView, limit: 1, select: r.id) |> Repo.one() do
      nil -> false
      _ -> true
    end
  end

  def all do
    Repo.all(ReportRowView)
  end

  def get_passenger(id) do
    case Repo.get(ReportRowView, id) do
      nil -> {:error, :passenger_not_found}
      passenger -> {:ok, passenger}
    end
  end

  def get_messages(passenger_id) do
    from(r in MessageLogSchema,
      where: r.passenger_id == ^passenger_id,
      order_by: [desc: r.inserted_at]
    )
    |> Repo.all()
  end

  def filter_passengers(params) do
    Filter.filter(params)
    |> Repo.all()
  end

  def filter_passengers_query(params) do
    Filter.filter(params)
  end

  def all_existing_packages() do
    from(p in ReportRowView, order_by: [asc: p.package], distinct: p.package, select: p.package)
    |> Repo.all()
  end

  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end

  def verify_message(params) do
    changeset = Message.changeset(%Message{}, params)

    case changeset.valid? do
      false -> {:error, changeset}
      true -> {:ok, Changeset.apply_changes(changeset)}
    end
  end
end
