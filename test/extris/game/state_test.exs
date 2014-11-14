defmodule Extris.Game.StateTest do
  use ExUnit.Case
  alias Extris.Game.State

  test "can get the cells the current shape is in from the game state" do
    state = %State{shape: :ell, rotation: 0, x: 5, y: 0}
    assert [{5, 0}, {5, 1}, {5, 2}, {6, 2}] == State.cells_for_shape(state)
  end
end
