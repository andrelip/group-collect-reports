defmodule GroupCollect.Report.ReportLine do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "report_lines" do
    field :birthday, :date
    field :email, :string
    field :full_name, :string
    field :gender, :string
    field :package, :string
    field :passenger_id, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def insert_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:passenger_id, :full_name, :gender, :email, :package, :birthday, :status])
    |> validate_required([
      :passenger_id,
      :full_name,
      :gender,
      :email,
      :package,
      :birthday,
      :status
    ])
    |> validate_inclusion(:gender, ["male", "female", "other", "prefer not to say"])
    |> validate_email_format
    |> validate_current_or_future_date(:birthday)
  end

  defp validate_current_or_future_date(%{changes: changes} = changeset, field) do
    do_validate_current_or_future_date(changeset, field, changes[field])
  end

  defp do_validate_current_or_future_date(changeset, field, date) do
    today = Timex.today()

    if Timex.compare(today, date) == 1 do
      changeset
    else
      changeset
      |> add_error(field, "Date in the past")
    end
  end

  defp validate_email_format(changeset) do
    changeset
    |> validate_format(:email, ~r/.{1,242}@.{1,242}/)

    # Regex for email validation is a very complex subject and most of the samples found on the internet
    # have exploits that could crash the server with a specific combination.
    #
    # The concensuous is to verify the email itself and just do a very basic and generic check for the @ character
  end
end
