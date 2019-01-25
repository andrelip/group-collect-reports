defmodule GroupCollect.Report.MessageLogSchema do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "message_logs" do
    field :body, :string
    field :media, :string
    field :passenger, :string
    field :subject, :string
    field :passenger_id, :id

    timestamps()
  end

  @doc false
  def insert_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:passenger_id, :subject, :body, :media])
    |> validate_required([:passenger_id, :subject, :body, :media])
  end
end
