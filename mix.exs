defmodule UeberauthWeixin.MixProject do
  use Mix.Project

  def project do
    [
      app: :ueberauth_weixin,
      version: "0.1.2",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Publish package
      name: "Ueberauth Weixin",
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
      {:jason, "~> 1.0"},
      {:oauth2, github: "elixir-wechat/oauth2", branch: "fix-serializer-not-used"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Wechat open platform OAuth2 strategy for Überauth."
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
