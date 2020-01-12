defmodule GiveawayWeb.Component.ParticipantsList do
  use Phoenix.LiveComponent

  alias GiveawayWeb.ComponentsView

  def mount(socket) do
    {:ok, assign(socket, :participants, [])}
  end

  def render(assigns) do
    ComponentsView.render("participant_list.html", assigns)
  end
end
