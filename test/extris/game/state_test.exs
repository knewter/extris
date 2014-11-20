defmodule Extris.Game.StateTest do
  use ExUnit.Case
  alias Extris.Game.State

  test "can get the cells the current shape is in from the game state" do
    state = %State{shape: :ell, rotation: 0, x: 5, y: 0}
    assert [{5, 0}, {5, 1}, {5, 2}, {6, 2}] == State.cells_for_shape(state)
  end

  test "clears out a single full line at the bottom" do
    state = %State{board: board_with_full_bottom_line}
    assert State.clear_lines(state).board == Extris.Game.State.Helpers.empty_board
  end

  def board_with_full_bottom_line do
    Extris.Game.State.Helpers.empty_board
    |> List.delete_at(0)
    |> List.insert_at(-1, full_line)
  end

  def full_line do
    [1, 2, 3, 4, 1, 2, 3, 4, 1, 2]
  end
end
