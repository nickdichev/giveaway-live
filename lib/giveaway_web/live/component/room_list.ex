defmodule GiveawayWeb.Component.RoomList do
  use Phoenix.LiveComponent

  alias Giveaway.Room

  alias GiveawayWeb.GiveawayView

  def mount(socket) do
     IO.inspect(socket, label: :component_mount)
     {:ok, assign(socket, :room_names, Room.get_rooms())}
  end

  def render(assigns) do
    IO.inspect(assigns, label: :component_render)
    GiveawayView.render("room_list.html", assigns)
  end
end
