defmodule Giveaway.RoomSupervisor do
  use DynamicSupervisor

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create_room(room_name) do
    DynamicSupervisor.start_child(__MODULE__, Giveaway.Server.child_spec(room_name: room_name))
  end

  def get_children() do
    for {:undefined, pid, _, _} <- DynamicSupervisor.which_children(__MODULE__), do: pid
  end

end
