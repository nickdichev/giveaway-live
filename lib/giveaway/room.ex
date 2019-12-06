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
  def create_room(room_name) do
    Supervisor.create_room(room_name: room_name, room_timeout: get_room_timeout(:milliseconds))
  end

  def get_participants(room_name), do: Server.get_participants(room_name)

  def join(room_name, participant_name), do: Server.join(room_name, participant_name)

  def determine_winner(room_name), do: Server.determine_winner(room_name)

  def get_winner(room_name), do: Server.get_winner(room_name)

  def get_room_timeout(:milliseconds), do: Application.get_env(:giveaway, :room_timeout, @default_room_timeout)

  def get_room_timeout(:minutes), do: div(get_room_timeout(:milliseconds), 60_000)

end
