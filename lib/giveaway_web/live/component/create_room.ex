defmodule GiveawayWeb.Component.CreateRoom do
  use Phoenix.LiveComponent

  alias Giveaway.Room
  alias Giveaway.Changeset.CreateRoom

  alias GiveawayWeb.ComponentsView

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ComponentsView.render("create_room.html", assigns)
  end

  def handle_event("validate", %{"create_room" => create_params}, socket) do
    changeset = changeset(create_params)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("create", %{"create_room" => create_params}, socket) do
    changeset = changeset(create_params)
    room_name = room_name(create_params)
    admin_password = admin_password(create_params) |> IO.inspect(label: :admin_password)

    if changeset.valid? do
      Room.create_room(room_name, admin_password)
      send(self(), {:create_redirect, room_name})
      {:noreply, socket}
    else
      {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp room_name(create_params), do: Map.get(create_params, "room_name")

  defp admin_password(create_params), do: Map.get(create_params, "admin_password")

  defp changeset(create_params) do
    %CreateRoom{}
    |> CreateRoom.changeset(create_params)
    |> Map.put(:action, :insert)
  end
end
