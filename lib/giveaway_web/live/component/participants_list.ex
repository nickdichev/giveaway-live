defmodule GiveawayWeb.Component.ParticipantsList do
  use Phoenix.LiveComponent

  alias GiveawayWeb.RoomView

  def mount(socket) do
    # {:ok, assign(socket, :participants, Room.get_participants(room_name))}
    {:ok, assign(socket, :participants, [])}
  end

  def render(assigns) do
    RoomView.render("participant_list.html", assigns)
  end
end
