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
      Shapes.height(state.shape, state.rotation) + state.y > 19 ->
        %State{shape: state.next_shape, x: 5, y: 0, next_shape: Shapes.random}
      true ->
        %State{state | y: state.y + 1}
    end
  end

  def overlay_shape(state) do
    shape = Shapes.shapes[state.shape]
    rotated_shape = shape |> Enum.at(state.rotation)
    width = Shapes.width(rotated_shape)
    height = Shapes.height(rotated_shape)
    new_board = for {row, row_i} <- Enum.with_index(state.board) do
      for {col, col_i} <- Enum.with_index(row) do
        rotated_shape_overlaps_cell = row_i >= state.y && row_i < state.y + height &&
                                      col_i >= state.x && col_i < state.x + width
        cond do
          # 0 in a shape is "transparent", and the shape is overlapping
          # with this col/row
          rotated_shape_overlaps_cell ->
            data_in_shape_cell = rotated_shape
                                 |> Enum.at(row_i - state.y)
                                 |> Enum.at(col_i - state.x)
            case data_in_shape_cell do
              0 -> state.board
                   |> Enum.at(row_i)
                   |> Enum.at(col_i)
              data -> Shapes.number(state.shape)
            end
          true ->
            state.board
            |> Enum.at(row_i)
            |> Enum.at(col_i)
        end
      end
    end
    %State{state|board: new_board}
  end
end
