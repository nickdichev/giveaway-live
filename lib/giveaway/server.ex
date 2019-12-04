defmodule Giveaway.Server do
  use GenServer

  defmodule State do
    defstruct [:room_name, :winner, :timeout, participants: []]
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

  def start_link(opts) do
    room_name = Keyword.fetch!(opts, :room_name)
    GenServer.start_link(__MODULE__, opts, name: via_tuple(room_name))
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

  def determine_winner(room_name) do
    GenServer.call(via_tuple(room_name), :determine_winner)
  end

  def get_winner(room_name) do
    GenServer.call(via_tuple(room_name), :get_winner)
  end

  #############
  # CALLBACKS #
  #############

  @impl GenServer
  @spec init(any) :: {:ok, Giveaway.Server.State.t(), timeout}
  def init(opts) do
    room_name = Keyword.fetch!(opts, :room_name)
    room_timeout = Keyword.fetch!(opts, :room_timeout)

    state = %State{
      room_name: room_name,
      timeout: room_timeout
    }

    {:ok, state, state.timeout}
  end

  @impl GenServer
  def handle_call(:get_name, _, state) do
    {:reply, state.room_name, state, state.timeout}
  end

  @impl GenServer
  def handle_call(:get_participants, _, state) do
    {:reply, state.participants, state, state.timeout}
  end

  @impl GenServer
  def handle_call({:join, name}, _, state) do
    new_participants = [name | state.participants]
    new_state = %{state | participants: new_participants}
    {:reply, new_state.participants, new_state, state.timeout}
  end

  @impl GenServer
  def handle_call(:determine_winner, _, state) do
    winner = Enum.random(state.participants)
    new_state = %{state | winner: winner}
    {:reply, winner, new_state, state.timeout}
  end

  def handle_call(:get_winner, _, state) do
    winner = Map.get(state, :winner, nil)
    {:reply, winner, state, state.timeout}
  end

  ###############
  # PRIVATE API #
  ###############

  defp via_tuple(room_name), do: {:via, Registry, {Giveaway.RoomRegistry, room_name}}
end
