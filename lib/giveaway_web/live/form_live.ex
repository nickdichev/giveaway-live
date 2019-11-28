defmodule GiveawayWeb.FormLive do
  use Phoenix.LiveView

  alias Giveaway.Changeset.CreateRoom
  alias GiveawayWeb.FormView

  def mount(_session, socket) do
    changeset = CreateRoom.changeset(%CreateRoom{})
    socket = assign(socket, :changeset, changeset)
    {:ok, socket}
  end

  def render(assigns) do
    FormView.render("create_room.html", assigns)
  end

  def handle_event("validate", %{"create_room" => create_params}, %{id: "create"} = socket) do
    changeset =
      CreateRoom.changeset(%CreateRoom{}, create_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("create", %{"create_room" => create_params}, %{id: "create"} = socket) do
    changeset = CreateRoom.changeset(%CreateRoom{}, create_params)

    with true <- changeset.valid?,
         {:ok, _pid} <- GiveawayServer.start_link(room_name: room_name(create_params)) do
           put_flash(socket, :info, "Created room #{room_name(create_params)}")
           {:no_reply, live_redirect(socket, to: "/giveaway/room")}
    else
      false -> {:noreply, assign(socket, :changeset, changeset)}
      {:error, {:already_started, _pid}} -> IO.puts("BAD")
      {:error, _reason} -> IO.puts("BAD)")
    end
  end

  defp room_name(create_params), do: Map.get(create_params, "room_name")
end
