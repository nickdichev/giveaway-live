defmodule Giveaway.Server do
  use GenServer

  defmodule State do
    defstruct [:room_name, :winner, participants: []]
  end

  def child_spec(opts) do
    room_name = Keyword.fetch!(opts, :room_name)

    %{
      id: room_name,
      start: {__MODULE__, :start_link, [room_name]},
    }
  end

  ##############
  # PUBLIC API #
  ##############

  def start_link(room_name) do
    GenServer.start_link(__MODULE__, room_name, name: via_tuple(room_name))
  end

  def get_name(room_pid) do
    GenServer.call(room_pid, :get_name)
  end

  #############
  # CALLBACKS #
  #############

  @impl GenServer
  @spec init(any) :: {:ok, Giveaway.Server.State.t()}
  def init(room_name) do
    state = %State{
      room_name: room_name
    }

    {:ok, state}
  end

  @impl GenServer
  def handle_call(:get_name, _, state) do
    {:reply, state.room_name, state}
  end

  ###############
  # PRIVATE API #
  ###############

  defp via_tuple(room_name), do: {:via, Registry, {Giveaway.RoomRegistry, room_name}}
end
