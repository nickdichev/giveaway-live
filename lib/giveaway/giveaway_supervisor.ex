defmodule GiveawayServer do
  use GenServer

  defmodule State do
    defstruct [:room_name, :winner, participants: []]
  end

  ##############
  # PUBLIC API #
  ##############

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  ##############
  # PUBLIC API #
  ##############

  @impl GenServer
  @spec init(any) :: {:ok, GiveawayServer.State.t()}
  def init(opts) do
    state = %State{
      room_name: Keyword.fetch!(opts, :room_name)
    }

    {:ok, state}
  end
end
