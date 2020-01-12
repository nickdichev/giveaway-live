defmodule GiveawayWeb.Component.ParticipantsList do
  use Phoenix.LiveComponent

  alias Giveaway.Room
  alias GiveawayWeb.ComponentsView

  def mount(socket) do
    {:ok, assign(socket, :participants, [])}
  end

  def render(assigns) do
    ComponentsView.render("participant_list.html", assigns)
  end

  def handle_event("delete", %{"participant" => participant_name}, socket) do
    send(self(), {:confirm_delete, participant_name})
    Room.remove(socket.assigns.room_name, participant_name)
    {:noreply, socket}
  end
end
