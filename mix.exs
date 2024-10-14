defmodule Apple.MixProject do
  use Mix.Project

  @version "0.5.0"
  @description "Utilities for building Apple SDKs."
  @source_url "https://github.com/cozy-elixir/apple"
  @changelog_url "https://github.com/cozy-elixir/apple/blob/v#{@version}/CHANGELOG.md"

  def project do
    [
      app: :apple,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: @description,
      source_url: @source_url,
      homepage_url: @source_url,
      docs: docs(),
      package: package(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jose, "~> 1.11"},
      {:jason, ">= 0.0.0", only: [:dev, :test]},
      {:ex_check, ">= 0.0.0", only: [:dev], runtime: false},
      {:credo, ">= 0.0.0", only: [:dev], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
      {:mix_audit, ">= 0.0.0", only: [:dev], runtime: false}
    ]
  end

  defp docs do
    [
      extras: ["README.md", "CHANGELOG.md"],
      source_url: @source_url,
      source_ref: "v#{@version}",
      groups_for_modules: groups_for_modules()
    ]
  end

  defp groups_for_modules do
    [
      Types: [
        Apple.Types.Developer,
        Apple.Types.AppStoreConnect
      ],
      "Service-specific utilities": [
        Apple.AppStoreServerAPI,
        Apple.WeatherKitRestAPI,
        Apple.MapsServerAPI
      ],
      "Misc utilities": [
        Apple.Signed
      ]
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{
        GitHub: @source_url,
        Changelog: @changelog_url
      }
    ]
  end

  defp aliases do
    [publish: ["hex.publish", "tag"], tag: &tag_release/1]
  end

  defp tag_release(_) do
    Mix.shell().info("Tagging release as v#{@version}")
    System.cmd("git", ["tag", "v#{@version}"])
    System.cmd("git", ["push", "--tags"])
  end
end
