defmodule GiveawayWeb.GiveawayLive do
  use Phoenix.LiveView

  alias GiveawayWeb.GiveawayView
  alias Giveaway.Changeset.CreateRoom

  def mount(_session, socket) do
    socket = assign(socket, :index_state, nil)
   {:ok, socket}
  end

  def render(assigns) do
    GiveawayView.render("index.html", assigns)
  end

  def handle_event("create_room", _value, socket) do
    socket = assign(socket, %{
      index_state: :create,
      changeset: CreateRoom.changeset(%CreateRoom{})
    })

    {:noreply, socket}
  end

  def handle_event("validate", %{"create_room" => create_params}, %{id: "create"} = socket) do
    changeset =
      CreateRoom.changeset(%CreateRoom{}, create_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("join_room", _value, socket) do
    {:noreply, assign(socket, :index_state, :join)}
  end
end
