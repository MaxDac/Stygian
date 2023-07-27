defmodule StygianWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      StygianWeb.Telemetry,
      # Start the Endpoint (http/https)
      StygianWeb.Endpoint
      # Start a worker by calling: StygianWeb.Worker.start_link(arg)
      # {StygianWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StygianWeb.Supervisor]

    # Executing migrations and seeding the database
    startup_task()

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StygianWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp startup_task do
    is_prod? =
      case Application.get_env(:real_football_web, :environment) do
        nil -> System.get_env("MIX_ENV") == "prod"
        value -> value == :prod
      end

    # Migrations should only run automatically in production
    if is_prod? do
      Logger.info("Executing automatic migrations.")
      StygianWeb.Release.migrate()
      StygianWeb.Release.seed()
    end
  end
end
