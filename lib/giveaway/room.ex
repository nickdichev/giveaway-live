defmodule Giveaway.Room do

  alias Giveaway.RoomSupervisor
  alias Giveaway.Server

  @doc """
  Get all running room names.
  """
  def get_room_names() do
    RoomSupervisor.get_children()
    |> Enum.map(&Server.get_name/1)
  end

  @doc """
  Create a new room with a given name.
  """
  def create_room(room_name), do: RoomSupervisor.create_room(room_name)

  def get_participants(room_name), do: Server.get_participants(room_name)

  def join(room_name, participant_name), do: Server.join(room_name, participant_name)

  def determine_winner(room_name), do: Server.determine_winner(room_name)

  def get_winner(room_name), do: Server.get_winner(room_name)
end
