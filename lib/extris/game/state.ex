defmodule Extris.Game.State.Helpers do
  @board_size %{
    x: 10,
    y: 20
  }

  def empty_board do
    for y <- (1..@board_size.y) do
      for x <- (1..@board_size.x) do
        0
      end
    end
  end
end

defmodule Extris.Game.State do
  alias Extris.Game.State.Helpers

  defstruct shape: :ell, rotation: 0, x: 5, y: 0, next_shape: :ell, board: Helpers.empty_board
end
