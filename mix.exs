defmodule WebhookMe.Mixfile do
  use Mix.Project

  def project do
    [app: :webhook_me,
     version: "0.2.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [
      :logger,
      :nadia,
      :hashids
    ]
    ++ env_apps(Mix.env, :dev,  [:maru, :exsync])
    ++ env_apps(Mix.env, :prod, [:maru]),
    mod: {WebhookMe, [Mix.env]}]
  end

  defp env_apps(env, env, list), do: list
  defp env_apps(_, _, _), do: []

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:nadia, "~> 0.4"},
     {:hashids, "~> 2.0"},
     {:maru, "~> 0.10.4"},
     {:exsync, "~> 0.1", only: :dev},
     {:distillery, "~> 0.10"},
     {:edib, "~> 0.8"},
     {:conform, "~> 2.1", override: true},
     {:credo, "~> 1.2", only: [:test, :dev]},
     {:mock, "~> 0.1.3", only: :test}
   ]
  end
end
