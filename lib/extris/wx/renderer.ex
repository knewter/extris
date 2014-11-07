defmodule Extris.Wx.Renderer do
  use Extris.WxImports
  alias Extris.Shapes

  @side 25.0
  @board_size %{
    x: 10,
    y: 20
  }

  def draw(state, panel) do
    dc = :wxPaintDC.new(panel)
    :wxPaintDC.clear(dc)
    do_draw(state, dc)
    :wxPaintDC.destroy(dc)
  end

  def do_draw(state, dc) do
    rotation = state.rotation
    shape = Shapes.shapes[state.shape]
    pen = :wx_const.wx_black_pen
    canvas = :wxGraphicsContext.create(dc)
    :wxGraphicsContext.setPen(canvas, pen)
    draw_board(canvas)
    draw_colored_shape(canvas, state.shape, Enum.at(shape, rotation), state.x, state.y)
  end

  def draw_shape(canvas, shape, x, y, brush) do
    # Specify position in 'grid units'
    for {row, row_i} <- Enum.with_index(shape) do
      for {col, col_i} <- Enum.with_index(row) do
        if(col == 1) do
          draw_square(canvas, x + col_i , y + row_i, brush)
        end
      end
    end
  end

  def draw_colored_shape(canvas, brush_name, shape, x, y) do
    brush = brush_for(brush_name)
    draw_shape(canvas, shape, x, y, brush)
  end

  def draw_square(canvas, x, y, brush) do
    :wxGraphicsContext.setBrush(canvas, brush)
    true_x = @side * x
    true_y = @side * y
    :wxGraphicsContext.drawRectangle(canvas, true_x, true_y, @side, @side)
  end

  def brush_for(:bar),   do: :wxBrush.new({0, 240, 255, 255})
  def brush_for(:jay),   do: :wxBrush.new({12, 0, 255, 255})
  def brush_for(:ell),   do: :wxBrush.new({255, 150, 0, 255})
  def brush_for(:ess),   do: :wxBrush.new({5, 231, 5, 255})
  def brush_for(:zee),   do: :wxBrush.new({255, 17, 17, 255})
  def brush_for(:oh),    do: :wxBrush.new({247, 255, 17, 255})
  def brush_for(:tee),   do: :wxBrush.new({100, 255, 17, 255})
  def brush_for(:board), do: :wxBrush.new({0, 0, 0, 255})

  def draw_board(canvas) do
    brush = brush_for(:board)
    for x <- (0..@board_size.x) do
      draw_square(canvas, x, @board_size.y, brush)
    end
    for y <- (0..@board_size.y) do
      draw_square(canvas, 0, y, brush)
      draw_square(canvas, @board_size.x, y, brush)
    end
  end
end
