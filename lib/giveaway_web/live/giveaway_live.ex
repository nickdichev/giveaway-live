defmodule GiveawayWeb.GiveawayLive do
  use Phoenix.LiveView

  alias Giveaway.Room
  alias Giveaway.Changeset.CreateRoom

  alias GiveawayWeb.GiveawayView
  alias GiveawayWeb.Router.Helpers, as: Routes

  def mount(_session, socket) do
    {:ok, assign(socket, %{
        index_state: nil,
        room_names: Giveaway.Room.get_room_names()
      })
    }
  end

  def render(assigns) do
    GiveawayView.render("index.html", assigns)
  end

  def handle_event("create_room", _value, socket) do
    socket = assign(socket, %{
      index_state: :create,
      changeset: CreateRoom.changeset(%CreateRoom{})
    })

    {:noreply, socket}
  end

  def handle_event("cancel", _value, socket) do
    {:noreply, assign(socket, :index_state, :nil)}
  end

  @doc """
  Handles the message the create room LiveComponent sends
  """
  def handle_info({:create_room, room_name}, socket) do
    case Room.create_room(room_name) do
      {:ok, _pid} ->
        {:noreply, live_redirect(socket, to: Routes.live_path(socket, GiveawayWeb.RoomLive, room_name))}
      {:error, {:already_started, _pid}} ->
        {:noreply, socket}
    end
  end
end
