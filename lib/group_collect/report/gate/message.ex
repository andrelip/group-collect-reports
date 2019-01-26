defmodule GroupCollect.Report.Gate.Message do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :subject, :string
    field :body, :string
    field :media, :string
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:subject, :body, :media])
    |> validate_required([:subject, :body, :media])
    |> validate_length(:subject, min: 3, max: 300)
    |> validate_length(:body, min: 1)
    |> validate_inclusion(:media, [
      "internal_message",
      "email"
    ])
  end
end
