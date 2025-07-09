defmodule PhoenixLiveViewFlashTimer.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/kurmetaubanov/phoenix_liveview_flash_timer"

  def project do
    [
      app: :phoenix_liveview_flash_timer,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      source_url: @source_url,
      homepage_url: @source_url
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix_live_view, "~> 0.20"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Automatically clear flash messages after a timeout in Phoenix LiveView applications.
    Works with both controller-set flash messages and LiveView put_flash calls.
    """
  end

  defp package do
    [
      name: "phoenix_liveview_flash_timer",
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      maintainers: ["Your Name"],
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE.md)
    ]
  end

  defp docs do
    [
      main: "PhoenixLiveViewFlashTimer",
      source_url: @source_url
    ]
  end
end
