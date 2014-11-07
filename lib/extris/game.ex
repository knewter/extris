defmodule Extris.Game do
  use GenServer

  alias Extris.Interaction
  alias Extris.Game.State
  alias Extris.Shapes

  ## Client API

  @doc """
  Start a game of Extris
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def stop(pid) do
    GenServer.cast(pid, :stop)
  end

  def tick(pid) do
    GenServer.cast(pid, :tick)
  end

  def handle_input(pid, input) do
    GenServer.cast(pid, {:handle_input, input})
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %State{shape: Shapes.random, next_shape: Shapes.random}}
  end

  def handle_cast(:stop, _state) do
    {:stop, :normal, :shutdown_ok, []}
  end
  def handle_cast(:tick, state) do
    {:noreply, tick_game(state)}
  end
  def handle_cast({:handle_input, input}, state) do
    {:noreply, Interaction.handle_input(state, input)}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def tick_game(state) do
    cond do
      Shapes.height(state.shape, state.rotation) + state.y > 19 ->
        %State{shape: state.next_shape, x: 5, y: 0, next_shape: Shapes.random}
      true ->
        %State{state | y: state.y + 1}
    end
  end
end
