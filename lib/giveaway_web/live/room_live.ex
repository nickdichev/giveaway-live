defmodule GiveawayWeb.RoomLive do
  use Phoenix.LiveView

  alias Giveaway.Room
  alias Giveaway.Changeset.JoinRoom

  alias GiveawayWeb.RoomView

  def mount(_session, socket) do
    assigns = %{
      index_state: nil,
    }

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    RoomView.render("index.html", assigns)
  end

  def handle_params(params, _uri, socket) do
    room_name = Map.get(params, "room_name")
    participants = Giveaway.Room.get_participants(room_name)

    assigns = %{
      room_name: room_name,
      participants: participants
    }

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("join_room", _value, socket) do
    changeset = JoinRoom.changeset(%JoinRoom{})

    assigns = %{
      index_state: :join_room,
      changeset: changeset
    }

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("cancel", _value, socket) do
    {:noreply, assign(socket, :index_state, nil)}
  end

  def handle_info({:join, participant}, socket) do
    room_name = socket.assigns.room_name

    assigns = %{
      participants: Room.join(room_name, participant),
      index_state: nil
    }

    {:noreply, assign(socket, assigns)}
  end
end
