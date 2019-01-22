defmodule GroupCollect.Report.Passenger do
  use Ecto.Schema
  import Ecto.Changeset

  schema "passengers" do
    field :birthday, :date
    field :email, :string
    field :full_name, :string
    field :gender, :string

    timestamps()
  end

  @doc false
  def changeset(passenger, attrs) do
    passenger
    |> cast(attrs, [:id, :full_name, :gender, :email, :birthday])
    |> validate_required([:id, :full_name, :gender, :email, :birthday])
  end
end
