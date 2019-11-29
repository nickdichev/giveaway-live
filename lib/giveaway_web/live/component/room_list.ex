defmodule GiveawayWeb.Component.RoomList do
  use Phoenix.LiveComponent

  alias Giveaway.Room

  alias GiveawayWeb.GiveawayView

  def mount(socket) do
     {:ok, assign(socket, :room_names, Room.get_room_names())}
  end

  def render(assigns) do
    GiveawayView.render("room_list.html", assigns)
  end
end
