defmodule Stygian.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Stygian.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Stygian.PubSub},
      # Start Finch
      {Finch, name: Stygian.Finch}
      # Start a worker by calling: Stygian.Worker.start_link(arg)
      # {Stygian.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Stygian.Supervisor)
  end
end
