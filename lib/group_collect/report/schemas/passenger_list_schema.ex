defmodule GroupCollect.Report.PassengerListSchema do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias GroupCollect.Repo

  schema "passenger_lists" do
    field :package, :string
    field :status, :string
    field :passenger_id, :id

    timestamps()
  end

  @doc false
  def find_or_update_changeset(passenger, attrs) do
    case Repo.get_by(__MODULE__, %{passenger_id: passenger.id}) do
      nil -> insert_changeset(passenger, attrs)
      passenger_list -> update_changeset(passenger_list, attrs)
    end
  end

  @doc false
  def update_changeset(passenger_list, attrs) do
    passenger_list
    |> cast(attrs, [:package, :status])
    |> validate_required([:package, :status])
  end

  @doc false
  def insert_changeset(passenger, attrs) do
    %__MODULE__{}
    |> cast(attrs, [:package, :status])
    |> validate_required([:package, :status])
    |> put_change(:passenger_id, passenger.id)
  end
end
