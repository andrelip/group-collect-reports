defmodule GroupCollect.Report.PassengerList do
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
end
