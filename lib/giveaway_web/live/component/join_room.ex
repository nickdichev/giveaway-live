defmodule GiveawayWeb.Component.JoinRoom do
  use Phoenix.LiveComponent

  alias Giveaway.Changeset.JoinRoom

  alias GiveawayWeb.RoomView

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    RoomView.render("join_room.html", assigns)
  end

  def handle_event("validate", %{"join_room" => join_params}, socket) do
    changeset = changeset(join_params)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("join", %{"join_room" => join_params}, socket) do
    changeset = changeset(join_params)
    participant_name = participant_name(join_params)

    if changeset.valid? do
      send(self(), {:join, participant_name})
      {:noreply, socket}
    else
      {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp changeset(join_params) do
    %JoinRoom{}
    |> JoinRoom.changeset(join_params)
    |> Map.put(:action, :insert)
  end

  defp participant_name(join_params), do: Map.get(join_params, "name")
end