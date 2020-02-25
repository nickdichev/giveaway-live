defmodule Giveaway.Room do
  alias Giveaway.Room.{Server, Supervisor}

  # 30 minutes
  @default_room_timeout 1_800_000

  @doc """
  Get all running room names.
  """
  def get_room_names() do
    Supervisor.get_children()
    |> Enum.map(&Server.get_name/1)
  end

  @doc """
  Create a new room with a given name.
  """
  def create_room(room_name, admin_password) do
    Supervisor.create_room(
      room_name: room_name,
      room_timeout: get_room_timeout(:milliseconds),
      admin_password: admin_password
    )

    Phoenix.PubSub.broadcast!(Giveaway.PubSub, "lobby", {:room_created, room_name})
  end

  def get_participants(room_name), do: Server.get_participants(room_name)

  def join(room_name, participant_name) do
    case Server.join(room_name, participant_name) do
      {:ok, _participants} ->
        Phoenix.PubSub.broadcast!(Giveaway.PubSub, "room:#{room_name}", {:join, participant_name})

      {:error, :already_joined} ->
        {:error, :already_joined}
    end
  end

  def remove(room_name, participant_name) do
    Server.remove(room_name, participant_name)
    Phoenix.PubSub.broadcast!(Giveaway.PubSub, "room:#{room_name}", {:remove, participant_name})
  end

  def determine_winner(room_name) do
    winner = Server.determine_winner(room_name)
    Phoenix.PubSub.broadcast!(Giveaway.PubSub, "room:#{room_name}", {:winner, winner})
  end

  def reset_winner(room_name) do
    Phoenix.PubSub.broadcast!(Giveaway.PubSub, "room:#{room_name}", {:winner, nil})
  end

  def get_winner(room_name), do: Server.get_winner(room_name)

  def get_room_timeout(:milliseconds),
    do: Application.get_env(:giveaway, :room_timeout, @default_room_timeout)

  def get_room_timeout(:minutes) do
    :milliseconds
    |> get_room_timeout()
    |> human_readable_timeout()
  end

  def human_readable_timeout(timeout) when is_integer(timeout) do
    div(timeout, 60_000)
  end

  def human_readable_timeout(:infinity), do: "infinity"

  def correct_password?(room_name, password) do
    Server.correct_password?(room_name, password)
  end
end
