defmodule CargueroTaskBunny.Mixfile do
  use Mix.Project

  @version "0.0.4"
  @description "Background processing application/library written in Elixir that uses RabbitMQ as a messaging backend"

  def project do
    [
      app: :carguero_task_bunny,
      version: @version,
      elixir: "~> 1.7.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "CargueroCargueroTaskBunny",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      dialyzer: [ignore_warnings: "dialyzer.ignore-warnings"],
      docs: [
        extras: ["README.md"],
        main: "readme",
        source_ref: "v#{@version}",
        source_url: "https://github.com/carguero/carguero_carguero_task_bunny"
      ],
      description: @description,
      package: package(),
      xref: [exclude: [Wobserver]]
    ]
  end

  defp package do
    [
      name: :carguero_task_bunny,
      files: [
        # Project files
        "mix.exs",
        "README.md",
        "LICENSE.md",
        # CargueroTaskBunny
        "lib/carguero_task_bunny.ex",
        "lib/carguero_task_bunny",
        # Tasks
        "lib/mix/tasks/carguero_task_bunny.queue.reset.ex"
      ],
      maintainers: [
        "Antonio Sagliocco",
        "Elliott Hilaire",
        "Francesco Grammatico",
        "Ian Luites",
        "Kenneth Lee",
        "Maria Calderon",
        "Ricardo Perez",
        "Tatsuya Ono",
        "CARGUERO team"
      ],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/carguero/carguero_carguero_task_bunny"}
    ]
  end

  def application do
    [
      extra_applications: [:logger, :amqp],
      mod: {CargueroTaskBunny, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:amqp, "~> 1.1.1"},
      {:jason, "~> 1.2"},

      # dev/test
      # {:credo, "~> 1.5", only: [:dev]},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.23.0", only: :dev},
      {:excoveralls, "~> 0.13.3", only: :test},
      {:inch_ex, "~> 2.0", only: [:dev, :test]},
      {:logger_file_backend, "~> 0.0.11", only: :test},
      {:meck, "~> 0.9.0", only: :test},
      {:poolboy, "~> 1.5"}
    ]
  end
end
