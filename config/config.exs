# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :group_collect,
  ecto_repos: [GroupCollect.Repo]

# Configures the endpoint
config :group_collect, GroupCollectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "C8XCnlTM4WafnspfHj1eow0I1HXarAnO8G9xoFFjlGTerQrebQILNCEryNh/qOLg",
  render_errors: [view: GroupCollectWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GroupCollect.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :group_collect, GroupCollect.Mailer, adapter: Bamboo.LocalAdapter
config :group_collect, GroupCollect.Mailer, default_from: "support@group_collect.com"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
