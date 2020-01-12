defmodule GiveawayWeb.Component.RoomList do
  use Phoenix.LiveComponent

  alias Giveaway.Room

  alias GiveawayWeb.ComponentsView

  def mount(socket) do
    {:ok, assign(socket, :room_names, Room.get_room_names())}
  end

  def render(assigns) do
    ComponentsView.render("room_list.html", assigns)
  end
end
