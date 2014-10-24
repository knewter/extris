defmodule Extris.Interaction do
  use Extris.WxImports
  alias Extris.Game.State

  @left 10
  @right 11

  @a 65
  @d 68
  @right_arrow 316
  @left_arrow 314
  @up_arrow 315

  def handle_input(state, wx(id: @left, event: wxCommand(type: :command_button_clicked))) do
    %State{state | rotation: rem(state.rotation - 1, 4)}
  end
  def handle_input(state, wx(id: @right, event: wxCommand(type: :command_button_clicked))) do
    %State{state | rotation: rem(state.rotation + 1, 4)}
  end
  def handle_input(state, wx(event: wxKey(keyCode: @a))) do
    %State{state | rotation: rem(state.rotation + 1, 4)}
  end
  def handle_input(state, wx(event: wxKey(keyCode: @d))) do
    %State{state | rotation: rem(state.rotation - 1, 4)}
  end
  def handle_input(state, wx(event: wxKey(keyCode: @right_arrow))) do
    %State{state | x: state.x + 1}
  end
  def handle_input(state, wx(event: wxKey(keyCode: @left_arrow))) do
    %State{state | x: state.x - 1}
  end
  def handle_input(state, wx(event: wxKey(keyCode: @up_arrow))) do
    %State{state | rotation: rem(state.rotation + 1, 4)}
  end
end
