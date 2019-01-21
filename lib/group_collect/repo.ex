defmodule GroupCollect.Repo do
  use Ecto.Repo,
    otp_app: :group_collect,
    adapter: Ecto.Adapters.Postgres
end
