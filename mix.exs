defmodule Tp1TallerGallo.MixProject do
  use Mix.Project

  def project do
    [
      app: :ledger,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: Ledger, path: "_build/dev/bin/ledger"],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
def deps do
  [
    {:optimus, "~> 0.2"},
    {:ecto_sql, "~> 3.7"},
    {:csv, "~> 3.0"}
  ]
end
end
