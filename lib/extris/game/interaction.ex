defmodule Extris.Game.Interaction do
  alias Extris.Game.State
  alias Extris.Shapes

  def handle_input(original_state, event) do
    new_state = do_handle_input(original_state, event)
    cond do
      valid?(new_state) -> new_state
      true -> original_state
    end
  end

  def do_handle_input(state, :rotate_ccw) do
    %State{state | rotation: rem(state.rotation - 1, 4)}
  end
  def do_handle_input(state, :rotate_cw) do
    %State{state | rotation: rem(state.rotation + 1, 4)}
  end
  def do_handle_input(state, :move_right) do
    %State{state | x: state.x + 1}
  end
  def do_handle_input(state, :move_left) do
    %State{state | x: state.x - 1}
  end
  def do_handle_input(state, _), do: state

  defp valid?(%State{x: x}) when x < 0, do: false
  defp valid?(state) do
    !past_right_side_of_board?(state) &&
    !collision_with_board?(state)
  end

  def collision_with_board?(state) do
    Enum.any?(State.cells_for_shape(state), fn(coords) ->
      State.cell_at(state, coords) != 0
    end)
  end

  def past_right_side_of_board?(state) do
    width = Shapes.width(state.shape, state.rotation)
    state.x + width >= 11
  end
end
