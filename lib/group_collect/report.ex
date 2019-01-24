defmodule GroupCollect.Report do
  @moduledoc """
  Public API for the Report bounded context.
  """
  alias GroupCollect.Report.ImportFromCSV

  defdelegate load_from_csv(data), to: ImportFromCSV
end
