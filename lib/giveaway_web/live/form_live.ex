defmodule GiveawayWeb.FormLive do
  use Phoenix.LiveComponent

  alias Giveaway.Changeset.CreateRoom
  alias GiveawayWeb.FormView

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    FormView.render("create_room.html", assigns)
  end

  def handle_event("validate", %{"create_room" => create_params}, socket) do
    changeset = changeset(create_params)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("create", %{"create_room" => create_params}, socket) do
    changeset = changeset(create_params)
    room_name = room_name(create_params)

    with true <- changeset.valid?,
         {:ok, _pid} <- GiveawayServer.start_link(room_name: room_name) do
           put_flash(socket, :info, "Created room #{room_name}")
           {:no_reply, live_redirect(socket, to: "/giveaway/room")}
    else
      false ->
        put_flash(socket, :error, "Could not create room #{room_name}")
        {:noreply, assign(socket, :changeset, changeset)}
      {:error, {:already_started, _pid}} -> IO.puts("BAD")
      {:error, _reason} -> IO.puts("BAD)")
    end
  end

  defp room_name(create_params), do: Map.get(create_params, "room_name")

  defp changeset(create_params) do
    %CreateRoom{}
    |> CreateRoom.changeset(create_params)
    |> Map.put(:action, :insert)
  end
end
