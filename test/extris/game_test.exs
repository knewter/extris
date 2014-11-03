defmodule Extris.GameTest do
  use ExUnit.Case
  alias Extris.Game
  alias Extris.Game.State

  test "The next piece becomes the current piece when the current piece hits the bottom" do
    state = %State{shape: :ell, next_shape: :oh, y: 17}
    new_state = Game.tick_game(state)
    assert new_state.shape == :oh
  end
end
