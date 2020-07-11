defmodule Meseeks.MixProject do
  use Mix.Project

  @source_url "https://github.com/j3rn/meseeks"

  def project do
    [
      app: :meseeks,
      name: "Meseeks",
      description: "Can do! A simple Elixir authorization system!",
      version: "0.1.0",
      source_url: @source_url,
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        licenses: ["MIT"],
        links: %{source: @source_url}
      ],
      docs: [
        main: "Meseeks"
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end
end
