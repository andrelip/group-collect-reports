defmodule GroupCollect.Report.PassengerSchema do
  @moduledoc false

  alias GroupCollect.Repo

  use Ecto.Schema
  import Ecto.Changeset

  schema "passengers" do
    field :birthday, :date
    field :email, :string
    field :full_name, :string
    field :gender, :string

    timestamps()
  end

  def find_or_update_changeset(attrs) do
    case Repo.get(__MODULE__, attrs[:passenger_id]) do
      nil -> insert_changeset(attrs)
      passenger -> update_changeset(passenger, attrs)
    end
  end

  @doc false
  def update_changeset(passenger, attrs) do
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
