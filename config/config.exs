# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :webhook_me, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:webhook_me, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
port =
  (System.get_env("PORT") || "8081")
  |> Integer.parse
  |> elem(0)

base_address = System.get_env("BASE_ADDRESS") || "http://localhost:#{port}"

token = System.get_env("TELEGRAM_BOT_TOKEN")

config :maru, WebhookMe,
  http: [port: port],
  versioning: [
    using: :path
  ]

config :nadia,
  token: token

config :webhook_me,
  base_address: base_address,
  hashids_salt: System.get_env("HASHIDS_SALT")

