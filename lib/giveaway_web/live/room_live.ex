defmodule GiveawayWeb.RoomLive do
  use Phoenix.LiveView

  alias Giveaway.Room
  alias Giveaway.Changeset.JoinRoom

  alias GiveawayWeb.RoomView
  alias GiveawayWeb.Router.Helpers, as: Routes
  alias GiveawayWeb.Live.Helpers, as: LiveHelpers

  def mount(_session, socket) do
    assigns = %{
      index_state: nil,
      subscribed: false
    }

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    RoomView.render("index.html", assigns)
  end

  def handle_params(params, _uri, socket) do
    room_name = Map.get(params, "room_name")
    participants = Giveaway.Room.get_participants(room_name)

    if LiveHelpers.subscribe?(connected?(socket), socket.assigns) do
      Phoenix.PubSub.subscribe(Giveaway.PubSub, "room:#{room_name}")
    end

    assigns = %{
      room_name: room_name,
      participants: participants,
      winner: Room.get_winner(room_name),
      subscribed: true,
      index_state: nil
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

  ####################################################
  # PubSub event handling                            #
  # I wish these could be moved into the component   #
  # however, LiveComponent does not implement        #
  # handle_info/2                                    #
  ####################################################

  def handle_info({:join, participant}, socket) do
    assigns = %{
      participants: [participant | socket.assigns.participants],
      index_state: nil
    }

    {:noreply, assign(socket, assigns)}
  end

  def handle_info({:remove, participant}, socket) do
    assigns = %{
      participants: Enum.reject(socket.assigns.participants, &(&1 == participant))
    }

    {:noreply, assign(socket, assigns)}
  end

  def handle_info({:winner, winner}, socket) do
    {:noreply, assign(socket, :winner, winner)}
  end
end
