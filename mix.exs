defmodule Extris.Mixfile do
  use Mix.Project

  def project do
    [app: :extris,
     version: "0.0.1",
     elixir: "~> 1.0.0 or ~> 1.1.0-dev",
     deps: deps,
     escript: escript
   ]
  end

  defp escript do
    [
      main_module: Extris.CLI,
      emu_args: "-noinput -elixir ansi_enabled true"
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [:logger],
      mod: { Extris, [] }
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      #{:esdl2, github: "ninenines/esdl2"},
      {:dogma, github: "lpil/dogma", only: :dev}
    ]
  end
end
