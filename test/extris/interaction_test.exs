defmodule Extris.InteractionTest do
  use ExUnit.Case
  alias Extris.Interaction
  alias Extris.Game.State
  use Extris.WxImports

  @state %State{
    x: 3,
    y: 3,
    rotation: 0,
    shape: :ell
  }

  test "unbound events don't change state" do
    q = wx(event: wxKey(keyCode: 81))
    new_state = Interaction.handle_input(@state, q)
    assert new_state == @state
  end

  test "up arrow rotates clockwise" do
    up = wx(event: wxKey(keyCode: 315))
    new_state = Interaction.handle_input(@state, up)
    assert new_state == %State{@state | rotation: 1}
  end

  test "left arrow moves left" do
    left = wx(event: wxKey(keyCode: 314))
    new_state = Interaction.handle_input(@state, left)
    assert new_state == %State{@state | x: 2}
  end

  test "right arrow moves right" do
    right = wx(event: wxKey(keyCode: 316))
    new_state = Interaction.handle_input(@state, right)
    assert new_state == %State{@state | x: 4}
  end

  test "left arrow does nothing if we're bumping against the left edge of the board" do
    state = %State{@state | x: 1}
    left = wx(event: wxKey(keyCode: 314))
    new_state = Interaction.handle_input(state, left)
    assert new_state == state
  end

  test "right arrow does nothing if we're bumping against the right edge of the board" do
    state = %State{@state | x: 9, shape: :oh}
    right = wx(event: wxKey(keyCode: 316))
    new_state = Interaction.handle_input(state, right)
    assert new_state == state
  end
end
