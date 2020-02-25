defmodule GiveawayWeb.Component.JoinRoom do
  use Phoenix.LiveComponent

  alias Giveaway.Room
  alias Giveaway.Changeset.JoinRoom

  alias GiveawayWeb.ComponentsView

  def mount(socket) do
    assigns = %{
      already_joined?: false
    }

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ComponentsView.render("join_room.html", assigns)
  end

  def handle_event("validate", %{"join_room" => join_params}, socket) do
    changeset = changeset(join_params)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("join", %{"join_room" => join_params}, socket) do
    changeset = changeset(join_params)
    participant_name = participant_name(join_params)

    # yikes
    with true <- changeset.valid?,
         :ok <- Room.join(socket.assigns.room_name, participant_name) do
      {:noreply, socket}
    else
      false -> {:noreply, assign(socket, :changeset, changeset)}
      {:error, :already_joined} -> {:noreply, assign(socket, :already_joined?, true)}
    end
  end

  defp changeset(join_params) do
    %JoinRoom{}
    |> JoinRoom.changeset(join_params)
    |> Map.put(:action, :insert)
  end

  defp participant_name(join_params), do: Map.get(join_params, "name")
end
