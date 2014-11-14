defmodule Extris.Interaction do
  use Extris.WxImports
  alias Extris.Game.State
  alias Extris.Shapes

  @left 10
  @right 11

  @a 65
  @d 68
  @right_arrow 316
  @left_arrow 314
  @up_arrow 315

  def handle_input(original_state, event) do
    new_state = do_handle_input(original_state, event)
    cond do
      valid?(new_state) -> new_state
      true -> original_state
    end
  end

  def do_handle_input(state, wx(id: @left, event: wxCommand(type: :command_button_clicked))) do
    %State{state | rotation: rem(state.rotation - 1, 4)}
  end
  def do_handle_input(state, wx(id: @right, event: wxCommand(type: :command_button_clicked))) do
    %State{state | rotation: rem(state.rotation + 1, 4)}
  end
  def do_handle_input(state, wx(event: wxKey(keyCode: @a))) do
    %State{state | rotation: rem(state.rotation + 1, 4)}
  end
  def do_handle_input(state, wx(event: wxKey(keyCode: @d))) do
    %State{state | rotation: rem(state.rotation - 1, 4)}
  end
  def do_handle_input(state, wx(event: wxKey(keyCode: @right_arrow))) do
    %State{state | x: state.x + 1}
  end
  def do_handle_input(state, wx(event: wxKey(keyCode: @left_arrow))) do
    %State{state | x: state.x - 1}
  end
  def do_handle_input(state, wx(event: wxKey(keyCode: @up_arrow))) do
    %State{state | rotation: rem(state.rotation + 1, 4)}
  end
  def do_handle_input(state, _), do: state

  defp valid?(%State{x: x}) when x < 1, do: false
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
