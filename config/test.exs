use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :group_collect, GroupCollectWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :group_collect, GroupCollect.Repo,
  username: "postgres",
  password: "postgres",
  database: "group_collect_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
