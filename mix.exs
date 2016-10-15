defmodule WebhookMe.Mixfile do
  use Mix.Project

  def project do
    [app: :webhook_me,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :amnesia]]
  end

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
    [{:amnesia, "~> 0.2.5"},
     {:nadia, "~> 0.4"},
     {:hashids, "~> 2.0"},
     {:maru, "~> 0.10.4"},
     {:exsync, "~> 0.1", only: :dev},
     {:exrm, "~> 1.0.8", override: true},
     {:edib, "~> 0.8"},
     {:conform, "~> 2.1", override: true},
     {:conform_exrm, "~> 1.0"},
     {:commander, "~> 0.1"},
     {:meter, "~> 0.1"},
     {:credo, "~> 0.4", only: [:test, :dev]},
     {:mock, "~> 0.1.3", only: :test}]
  end
end
