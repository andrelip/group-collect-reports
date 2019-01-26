defmodule GroupCollectWeb.Report.ChartView do
  use GroupCollectWeb, :view

  def include_wizard_check(params) do
    case params["include_wizard"] do
      "true" -> "checked"
      _ -> ""
    end
  end
end
