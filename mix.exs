defmodule UeberauthWeixin.MixProject do
  use Mix.Project

  def project do
    [
      app: :ueberauth_weixin,
      version: "0.1.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Publish package
      name: "Ueberauth Weixin Strategy",
      description: description(),
      package: package()
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
      {:ueberauth, "~> 0.6"},
      {:httpoison, "~> 1.0"},
      {:jason, "~> 1.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp description do
    "An Ueberauth strategy for open.weixin.qq.com authentication."
  end

  defp package do
    [
      name: :ueberauth_weixin,
      licenses: ["MIT"],
      maintainers: ["goofansu"],
      links: %{"Github" => "https://github.com/elixir-wechat/ueberauth_weixin"}
    ]
  end
end
