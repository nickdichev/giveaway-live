defmodule GiveawayWeb.GiveawayLive do
  use Phoenix.LiveView

  alias GiveawayWeb.GiveawayView

  def mount(_session, socket) do
    socket = assign(socket, :index_state, nil)
   {:ok, socket}
  end

  def render(assigns) do
    GiveawayView.render("index.html", assigns)
  end

  def handle_event("create_room", _value, socket) do
    {:noreply, assign(socket, :index_state, :create)}
  end

  def handle_event("join_room", _value, socket) do
    {:noreply, assign(socket, :index_state, :join)}
  end
end
