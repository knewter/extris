defmodule Extris.Wx.Interaction do
  use Extris.Wx.Imports
  alias Extris.Game.State
  alias Extris.Shapes

  @left 10
  @right 11

  @a 65
  @d 68
  @right_arrow 316
  @left_arrow 314
  @up_arrow 315

  def create_game_event(wx(id: @left, event: wxCommand(type: :command_button_clicked))) do
    :rotate_ccw
  end
  def create_game_event(wx(event: wxKey(keyCode: @d))) do
    :rotate_ccw
  end
  def create_game_event(wx(id: @right, event: wxCommand(type: :command_button_clicked))) do
    :rotate_cw
  end
  def create_game_event(wx(event: wxKey(keyCode: @a))) do
    :rotate_cw
  end
  def create_game_event(wx(event: wxKey(keyCode: @right_arrow))) do
    :move_right
  end
  def create_game_event(wx(event: wxKey(keyCode: @left_arrow))) do
    :move_left
  end
  def create_game_event(wx(event: wxKey(keyCode: @up_arrow))) do
    :rotate_cw
  end
  def create_game_event(_), do: :unknown_event
end
