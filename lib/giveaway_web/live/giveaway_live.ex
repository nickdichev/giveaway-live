defmodule GiveawayWeb.GiveawayLive do
  use Phoenix.LiveView

  alias Giveaway.Changeset.CreateRoom

  alias GiveawayWeb.GiveawayView

  def mount(_session, socket) do
    {:ok, assign(socket, %{
        index_state: nil,
        room_names: Giveaway.Room.get_rooms()
      })
    }
  end

  def render(assigns) do
    IO.inspect(assigns, label: :view_render)
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
  def handle_info({:create_redirect, room_name}, socket) do
    {:noreply, live_redirect(socket, to: "/giveaway/room/#{room_name}")}
  end
end
