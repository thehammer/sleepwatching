# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sleepwatching,
  ecto_repos: [Sleepwatching.Repo]

# Configures the endpoint
config :sleepwatching, Sleepwatching.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gfZi0Q0n2kKC7HScESodXdCwJIgR9j20tPUSuvs5yAfr3k/Zg5T3trXdtv7EpEzE",
  render_errors: [view: Sleepwatching.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Sleepwatching.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
