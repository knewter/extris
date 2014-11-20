defmodule Extris.Game.State.Helpers do
  @board_size %{
    x: 10,
    y: 20
  }

  def empty_board do
    for y <- (1..@board_size.y), do: empty_line
  end

  def empty_line do
    for x <- (1..@board_size.x), do: 0
  end
end

defmodule Extris.Game.State do
  alias Extris.Game.State.Helpers
  alias Extris.Shapes

  defstruct shape: :ell, rotation: 0, x: 5, y: 0, next_shape: :ell, board: Helpers.empty_board

  def cells_for_shape(state) do
    shape = Shapes.shapes[state.shape]
    rotated_shape = shape |> Enum.at(state.rotation)
    for {row, row_i} <- Enum.with_index(rotated_shape) do
      for {col, col_i} <- Enum.with_index(row), col != 0 do
        {col_i + state.x, row_i + state.y}
      end
    end |> List.flatten
  end

  def cell_at(state, {x, y}) do
    state.board
    |> Enum.at(y)
    |> Enum.at(x)
  end

  def clear_lines(state) do
    %__MODULE__{state|board: clear_lines(state.board, [], [])}
  end
  defp clear_lines([line|rest], accum, cleared) do
    case clearable?(line) do
      true  -> clear_lines(rest, accum, cleared ++ [line])
      false -> clear_lines(rest, accum ++ [line], cleared)
    end
  end
  defp clear_lines([], accum, cleared) do
    empty_lines = for _ <- cleared do
      Helpers.empty_line
    end
    empty_lines ++ accum
  end

  def clearable?(line) do
    line
    |> Enum.all?(fn(x) -> x != 0 end)
  end
end
