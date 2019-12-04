defmodule GiveawayWeb.GiveawayLive do
  use Phoenix.LiveView

  alias Giveaway.Changeset.CreateRoom

  alias GiveawayWeb.GiveawayView
  alias GiveawayWeb.Router.Helpers, as: Routes

  def mount(_session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(Giveaway.PubSub, "lobby")

    assigns = %{
      index_state: nil,
      room_names: Giveaway.Room.get_room_names(),
      room_timeout: Giveaway.Room.get_room_timeout(:minutes)
    }

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    GiveawayView.render("index.html", assigns)
  end

  @doc """
  Handles the click event on the "create room" button.
  """
  def handle_event("create_room", _value, socket) do
    socket = assign(socket, %{
      index_state: :create,
      changeset: CreateRoom.changeset(%CreateRoom{})
    })

    {:noreply, socket}
  end

  @doc """
  Handles the click event on the "cancel" button.
  """
  def handle_event("cancel", _value, socket) do
    {:noreply, assign(socket, :index_state, :nil)}
  end

  @doc """
  Handles the room_created message the LiveComponent sends.

  This will update the room list on anyone looking at the lobby.
  """
  def handle_info({:room_created, room_name}, socket) do
    assigns = %{
      room_names: [room_name | socket.assigns.room_names],
      index_state: nil
    }

    {:noreply, assign(socket, assigns)}
  end

  def handle_info({:create_redirect, room_name}, socket) do
    {:noreply, live_redirect(socket, to: Routes.live_path(socket, GiveawayWeb.RoomLive, room_name))}
  end
end
