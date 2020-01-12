defmodule GiveawayWeb.RoomAdminLive do
  use Phoenix.LiveView

  alias Giveaway.Room
  alias Giveaway.Changeset.JoinRoom

  alias GiveawayWeb.RoomAdminView

  def mount(_session, socket) do
    assigns = %{
      index_state: nil
    }

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    RoomAdminView.render("index.html", assigns)
  end

  def handle_params(params, _uri, socket) do
    room_name = Map.get(params, "room_name")
    participants = Giveaway.Room.get_participants(room_name)

    if connected?(socket), do: Phoenix.PubSub.subscribe(Giveaway.PubSub, "room:#{room_name}")

    assigns = %{
      room_name: room_name,
      participants: participants,
      winner: Room.get_winner(room_name)
    }

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("determine_winner", _value, socket) do
    winner = Room.determine_winner(socket.assigns.room_name)

    {:noreply, assign(socket, :winner, winner)}
  end

  def handle_info({:join, participant}, socket) do
    assigns = %{
      participants: [participant | socket.assigns.participants],
      index_state: nil
    }

    {:noreply, assign(socket, assigns)}
  end

  def handle_info({:winner, winner}, socket) do
    {:noreply, assign(socket, :winner, winner)}
  end
end
