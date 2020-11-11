defmodule ECSV.Mixfile do
  use Mix.Project

  def project() do
    [
      app: :ecsv,
      version: "0.2.0",
      elixir: "~> 1.9",
      description: "CSV Stream Parser",
      package: package(),
      deps: deps()
    ]
  end

  def package do
    [
      files: ~w(doc src mix.exs LICENSE),
      licenses: ["ISC"],
      maintainers: ["Namdak Tonpa"],
      name: :ecsv,
      links: %{"GitHub" => "https://github.com/erpuno/ecsv"}
    ]
  end

  def application() do
    [mod: {:ecsv, []}]
  end

  def deps() do
    [
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end
end
