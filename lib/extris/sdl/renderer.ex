defmodule Extris.SDL.Renderer do
  alias Extris.Shapes

  @side 25

  def draw(state, renderer) do
    :ok = :sdl_renderer.set_draw_color(renderer, 255, 255, 255, 255)
    :ok = :sdl_renderer.clear(renderer)
    do_draw(state, renderer)
  end

  def do_draw(state, renderer) do
    set_brush(renderer, :board)
    draw_board(renderer, state)
    :ok = :sdl_renderer.present(renderer)
  end

  def draw_square(renderer, x, y, brush) do
    set_brush(renderer, brush)
    true_x = @side * x
    true_y = @side * y
    :ok = :sdl_renderer.fill_rect(renderer, %{x: true_x, y: true_y, w: @side, h: @side})
  end

  def draw_board(renderer, state) do
    draw_frame(renderer, state)
    for {row, row_i} <- Enum.with_index(state.board) do
      for {col, col_i} <- Enum.with_index(row) do
        case col do
          0 -> true
          n -> draw_square(renderer, col_i, row_i, brush_for(Shapes.by_number(n)))
        end
      end
    end
  end

  def draw_frame(renderer, state) do
    brush = brush_for(:board)
    board_width = Shapes.width(state.board)
    board_height = Shapes.height(state.board)
    for x <- (0..board_width) do
      draw_square(renderer, x, board_height, brush)
    end
    for y <- (0..board_height) do
      draw_square(renderer, 0, y, brush)
      draw_square(renderer, board_width, y, brush)
    end
  end

  def brush_for(:ell),   do: [255, 150, 0, 255]
  def brush_for(:jay),   do: [12, 0, 255, 255]
  def brush_for(:ess),   do: [5, 231, 5, 255]
  def brush_for(:zee),   do: [255, 17, 17, 255]
  def brush_for(:bar),   do: [0, 240, 255, 255]
  def brush_for(:oh),    do: [247, 255, 17, 255]
  def brush_for(:tee),   do: [100, 255, 17, 255]
  def brush_for(:board), do: [0, 0, 0, 255]

  def set_brush(renderer, brush_type) when is_list(brush_type) do
    :ok = apply(:sdl_renderer, :set_draw_color, [renderer] ++ brush_type)
  end
  def set_brush(renderer, brush_type) when is_atom(brush_type) do
    set_brush(renderer, brush_for(brush_type))
  end
end
