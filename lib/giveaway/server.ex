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

  def get_participants(room_name) do
    GenServer.call(via_tuple(room_name), :get_participants)
  end

  def join(room_name, participant_name) do
    GenServer.call(via_tuple(room_name), {:join, participant_name})
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

  @impl GenServer
  def handle_call(:get_participants, _, state) do
    {:reply, state.participants, state}
  end

  @impl GenServer
  def handle_call({:join, name}, _, state) do
    new_participants = [name | state.participants]
    new_state = %{state | participants: new_participants}
    {:reply, new_state.participants, new_state}
  end

  ###############
  # PRIVATE API #
  ###############

  defp via_tuple(room_name), do: {:via, Registry, {Giveaway.RoomRegistry, room_name}}
end
