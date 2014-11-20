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
    state_with_overlaid_shape = overlay_shape(state)
    {:reply, state_with_overlaid_shape, state}
  end

  def handle_info(:tick, state) do
    {:noreply, tick_game(state)}
  end

  def tick_game(state) do
    cond do
      collision_with_bottom?(state) || collision_with_board?(state) ->
        IO.puts "collision"
        IO.inspect state.board
        new_state = overlay_shape(state)
        IO.puts "overlaid shape"
        IO.inspect new_state.board
        cleared_state = State.clear_lines(new_state)
        IO.puts "cleared state"
        IO.inspect cleared_state.board
        %State{cleared_state | shape: state.next_shape, x: 5, y: 0, next_shape: Shapes.random }
      true ->
        %State{state | y: state.y + 1}
    end
  end

  def collision_with_bottom?(state) do
    Shapes.height(state.shape, state.rotation) + state.y > 19
  end

  def collision_with_board?(state) do
    next_coords = for {x, y} <- State.cells_for_shape(state), do: {x, y+1}
    Enum.any?(next_coords, fn(coords) ->
      State.cell_at(state, coords) != 0
    end)
  end

  def overlay_shape(state) do
    new_board = for {row, row_i} <- Enum.with_index(state.board) do
      for {col, col_i} <- Enum.with_index(row) do
        rotated_shape_overlaps_cell = Enum.member?(State.cells_for_shape(state), {col_i, row_i})
        cond do
          rotated_shape_overlaps_cell -> Shapes.number(state.shape)
          true -> col
        end
      end
    end
    %State{state|board: new_board}
  end
end
