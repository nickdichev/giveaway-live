defmodule Giveaway.Room do

  alias Giveaway.RoomSupervisor
  alias Giveaway.Server

  def get_rooms() do
    RoomSupervisor.get_children()
    |> Enum.map(&Server.get_name/1)
  end

  def create_room(room_name), do: RoomSupervisor.create_room(room_name)
end
