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

  def handle_event("reset_winner", _value, socket) do
    Room.reset_winner(socket.assigns.room_name)
    {:noreply, assign(socket, :winner, nil)}
  end

  # Modal handling

  def handle_info({:confirm_delete, _participant}, socket) do
    {:no_reply, socket}
  end

  def handle_event("left_button_click", _value, socket) do
    {:noreply, socket}
  end

  def handle_event("right_button_click", _value, socket) do
    {:noreply, socket}
  end

  ####################################################
  # PubSub event handling                            #
  # I wish these could be moved into the component   #
  # however, LiveComponent does not implement        #
  # handle_info/2                                    #
  ####################################################

  def handle_info({:join, participant}, socket) do
    assigns = %{
      participants: [participant | socket.assigns.participants]
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
