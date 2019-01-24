defmodule GroupCollect.Report.ReportRowView do
  @moduledoc false

  use Ecto.Schema

  schema "report_rows" do
    field :birthday, :date
    field :email, :string
    field :full_name, :string
    field :gender, :string
    field :package, :string
    field :status, :string
  end
end
