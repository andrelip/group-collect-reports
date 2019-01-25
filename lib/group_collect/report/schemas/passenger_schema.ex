defmodule GroupCollect.Report.PassengerSchema do
  @moduledoc false

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
    |> cast(attrs, [:full_name, :gender, :email, :birthday])
    |> validate_required([:full_name, :gender, :email, :birthday])
  end

  @doc false
  def insert_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:id, :full_name, :gender, :email, :birthday])
    |> validate_required([:id, :full_name, :gender, :email, :birthday])
    |> unique_constraint(:id, name: :passengers_pkey)
  end
end
