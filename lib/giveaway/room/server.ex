defmodule Giveaway.Room.Server do
  use GenServer

  require Logger

  defmodule State do
    defstruct [:room_name, :winner, :timeout, :admin_password, participants: []]
  end

  def child_spec(opts) do
    room_name = Keyword.fetch!(opts, :room_name)

    %{
      id: room_name,
      start: {__MODULE__, :start_link, [room_name]},
      restart: :transient
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

  def remove(room_name, participant_name) do
    GenServer.call(via_tuple(room_name), {:remove, participant_name})
  end

  def determine_winner(room_name) do
    GenServer.call(via_tuple(room_name), :determine_winner)
  end

  def get_winner(room_name) do
    GenServer.call(via_tuple(room_name), :get_winner)
  end

  def correct_password?(room_name, password) do
    GenServer.call(via_tuple(room_name), {:check_password, password})
  end

  #############
  # CALLBACKS #
  #############

  @impl GenServer
  @spec init(any) :: {:ok, Giveaway.Room.Server.State.t(), timeout}
  def init(opts) do
    room_name = Keyword.fetch!(opts, :room_name)
    admin_password = Keyword.fetch!(opts, :admin_password)
    room_timeout = timeout(room_name, opts)

    state = %State{
      room_name: room_name,
      timeout: room_timeout,
      admin_password: admin_password
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
    if name in state.participants do
      {:reply, {:error, :already_joined}, state, state.timeout}
    else
      new_participants = [name | state.participants]
      new_state = %{state | participants: new_participants}
      {:reply, {:ok, new_state.participants}, new_state, state.timeout}
    end
  end

  def handle_call({:remove, name}, _, state) do
    new_participants = Enum.reject(state.participants, &(&1 == name))
    new_state = %{state | participants: new_participants}
    {:reply, new_state.participants, new_state, state.timeout}
  end

  @impl GenServer
  @doc """
  Determine winner when room is empty (no participants).
  """
  def handle_call(:determine_winner, _, %{participants: []} = state) do
    {:reply, :noop, state, state.timeout}
  end

  @impl GenServer
  def handle_call(:determine_winner, _, state) do
    winner = Enum.random(state.participants)
    new_state = %{state | winner: winner}
    {:reply, winner, new_state, state.timeout}
  end

  @impl GenServer
  def handle_call(:get_winner, _, state) do
    winner = Map.get(state, :winner, nil)
    {:reply, winner, state, state.timeout}
  end

  @impl GenServer
  def handle_call({:check_password, password}, _, state) do
    valid = password == state.admin_password
    {:reply, valid, state, state.timeout}
  end

  @impl GenServer
  def handle_info(:timeout, state) do
    Logger.info("Stopping room #{state.room_name}")
    # TODO: move this broadcast call somewhere? (can that even be done?)
    Phoenix.PubSub.broadcast!(Giveaway.PubSub, "lobby", {:room_timeout, state.room_name})
    {:stop, :shutdown, state}
  end

  ###############
  # PRIVATE API #
  ###############

  defp via_tuple(room_name), do: {:via, Registry, {Giveaway.RoomRegistry, room_name}}

  defp timeout(room_name, opts) do
    if room_name == "chrissimonmusic" do
      :infinity
    else
      Keyword.fetch!(opts, :room_timeout)
    end
  end
end
