defmodule GroupCollect.Report.ReportRow do
  @moduledoc false
  defstruct([:passenger_id, :full_name, :gender, :email, :package, :birthday, :status])

  @type t :: %__MODULE__{
          passenger_id: String.t(),
          full_name: String.t(),
          gender: String.t(),
          gender: String.t(),
          email: String.t(),
          package: String.t(),
          birthday: String.t(),
          status: String.t()
        }
end
