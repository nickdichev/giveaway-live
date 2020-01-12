defmodule GiveawayWeb.RoomAdminLive do
  use Phoenix.LiveView

  alias Giveaway.Room
  alias Giveaway.Changeset.JoinRoom

  alias GiveawayWeb.RoomAdminView
  alias GiveawayWeb.Router.Helpers, as: Routes

  def mount(_session, socket) do
    assigns = %{
      index_state: nil
    }

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    RoomAdminView.render("index.html", assigns)
  end

  # We can't pattern match on the final segment of the URI, so we "override"
  # handle_params/3 with our version of handle_params/4 where we can pattern match
  def handle_params(params, uri, socket),
    do: handle_params(params, uri, last_path_segment(uri), socket)

  def handle_params(_params, _uri, "confirm_delete_participant", socket) do
    assigns = %{
      show_modal: true
    }

    {:noreply, assign(socket, assigns)}
  end

  def handle_params(params, _uri, _last_segment, socket) do
    room_name = Map.get(params, "room_name")
    participants = Giveaway.Room.get_participants(room_name)

    if connected?(socket), do: Phoenix.PubSub.subscribe(Giveaway.PubSub, "room:#{room_name}")

    assigns = %{
      room_name: room_name,
      participants: participants,
      winner: Room.get_winner(room_name),
      show_modal: false
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

  def handle_info({:confirm_participant_delete, _participant}, socket) do
    IO.inspect("redirecting")

    {:noreply,
     live_redirect(socket,
       to:
         Routes.confirm_delete_participant_path(
           socket,
           GiveawayWeb.RoomAdminLive,
           socket.assigns.room_name
         ),
       replace: true
     )}
  end

  def handle_info({:modal_button_clicked, _map}, socket) do
    # Room.remove(socket.assigns.room_name, participant_name)
    {:no_reply, socket}
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

  ## Private ##

  defp last_path_segment(uri) do
    uri
    |> URI.parse()
    |> Map.get(:path)
    |> String.split("/", trim: true)
    |> List.last()
  end
end
