defmodule GiveawayWeb.RoomLive do
  use Phoenix.LiveView

  alias GiveawayWeb.RoomView

  def mount(_session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    RoomView.render("index.html", assigns)
  end

  @doc """
  Handle the redirect. Grab the room name and store it in the socket.
  """
  def handle_params(params, _uri, socket) do
    room_name = Map.get(params, "room_name")
    {:noreply, assign(socket, :room_name, room_name)}
  end
end
