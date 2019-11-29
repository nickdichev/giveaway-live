defmodule GiveawayWeb.Component.CreateRoom do
  use Phoenix.LiveComponent

  alias Giveaway.Room
  alias Giveaway.Changeset.CreateRoom

  alias GiveawayWeb.GiveawayView

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    GiveawayView.render("create_room.html", assigns)
  end

  def handle_event("validate", %{"create_room" => create_params}, socket) do
    changeset = changeset(create_params)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("create", %{"create_room" => create_params}, socket) do
    changeset = changeset(create_params)
    room_name = room_name(create_params)

    if changeset.valid? do
      {:ok, _pid} = Room.create_room(room_name)
      Phoenix.PubSub.broadcast!(Giveaway.PubSub, "lobby", {:room_created, room_name})
      {:noreply, socket}
    else
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp room_name(create_params), do: Map.get(create_params, "room_name")

  defp changeset(create_params) do
    %CreateRoom{}
    |> CreateRoom.changeset(create_params)
    |> Map.put(:action, :insert)
  end
end
