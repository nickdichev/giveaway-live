defmodule Giveaway.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      GiveawayWeb.Endpoint,
      Giveaway.Room.Supervisor,
      {Registry, [keys: :unique, name: Giveaway.RoomRegistry]}
    ]

    opts = [strategy: :one_for_one, name: Giveaway.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GiveawayWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
