defmodule GroupCollect.Report.PassengerList do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "passenger_lists" do
    field :package, :string
    field :status, :string
    field :passenger_id, :id

    timestamps()
  end

  @doc false
  def changeset(passenger_list, attrs) do
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
