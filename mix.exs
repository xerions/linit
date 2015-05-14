defmodule Linit.Mixfile do
  use Mix.Project

  def project do
    [app: :linit,
     version: "0.1.0",
     elixir: "~> 1.1-dev",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end
end
