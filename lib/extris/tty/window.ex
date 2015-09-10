defmodule Extris.TTY.Window do
  @refresh_interval 100
  @block "\x{2588}\x{2588}"
  @vert_line "\x{2502}"
  @mid_bar "\x{2500}"
  @top_left "\x{250c}"
  @top_right "\x{2510}"
  @bottom_left "\x{2514}"
  @bottom_right "\x{2518}"

  def start(game) do
    loop(game)
  end

  defp loop(game) do
    state = Extris.Game.get_state(game)
    IO.write [
      clear_screen,
      draw_board(state.board)
    ]
    :timer.sleep @refresh_interval
    loop(game)
  end

  defp clear_screen do
    [
      IO.ANSI.home,
      IO.ANSI.clear
    ]
  end

  defp draw_board(board) do
    width = Enum.count hd(board)
    [
      top_bar(width),
      Enum.map(board, &draw_line/1),
      bottom_bar(width)
    ]
  end

  defp draw_line(line) do
    [@vert_line, Enum.map(line, &draw_cell/1), @vert_line, "\r\n"]
  end

  defp top_bar(width) do
    [@top_left, String.duplicate("#{@mid_bar}#{@mid_bar}", width), @top_right, "\r\n"]
  end

  defp bottom_bar(width) do
    [@bottom_left, String.duplicate("#{@mid_bar}#{@mid_bar}", width), @bottom_right, "\r\n"]
  end

  defp draw_cell(0), do: "  "
  defp draw_cell(n) do
    n
    |> Extris.Shapes.by_number
    |> color
    |> draw_block
  end

  def draw_block(color) when is_list(color) do
    [Enum.map(color, fn(x) -> apply(IO.ANSI, x, []) end), @block, IO.ANSI.reset]
  end
  def draw_block(color), do: draw_block([color])

  defp color(:ell), do: :yellow
  defp color(:jay), do: [:bright, :red]
  defp color(:ess), do: :red
  defp color(:zee), do: :green
  defp color(:bar), do: [:bright, :cyan]
  defp color(:oh),  do: [:bright, :yellow]
  defp color(:tee), do: :magenta
end
