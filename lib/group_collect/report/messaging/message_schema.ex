defmodule GroupCollect.Report.MessageSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string
    field :subject, :string
    field :passenger_id, :id

    timestamps()
  end

  @doc false
  def insert_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:passenger_id, :subject, :body])
    |> validate_required([:passenger_id, :subject, :body])
  end
end
