defmodule Extris.Window do
  @moduledoc """

  For now, Window exists to toy with the options I might have for building out
  a tetris game display using wx in Elixir.

  """

  @title 'ExTris'
  @side 25.0

  require Record
  Record.defrecordp :wx, Record.extract(:wx, from_lib: "wx/include/wx.hrl")
  Record.defrecordp :wxClose, Record.extract(:wxClose, from_lib: "wx/include/wx.hrl")
  Record.defrecordp :wxCommand, Record.extract(:wxCommand, from_lib: "wx/include/wx.hrl")

  alias Extris.Shapes

  def start(config) do
    do_init(config)
  end

  def init(config) do
    :wx.batch(fn() -> do_init(config) end)
  end

  def do_init(_config) do
    wx = :wx.new
    frame = :wxFrame.new(wx, -1, @title)
    panel = :wxPanel.new(frame)
    main_sizer = :wxBoxSizer.new(:wx_const.wx_vertical)
    sizer = :wxStaticBoxSizer.new(:wx_const.wx_vertical, panel, label: "Extris")
    canvas = :wxPanel.new(panel, style: :wx_const.wx_full_repaint_on_resize, size: {300,300})
    :wxPanel.connect(canvas, :paint, [:callback])
    :wxSizer.add(sizer, canvas, flag: :wx_const.wx_expand, proportion: 1)
    one = :wxButton.new(frame, 10, label: '1')
    :wxSizer.add(main_sizer, one)
    :wxSizer.add(main_sizer, sizer)
    :wxSizer.add(main_sizer, sizer, flag: :wx_const.wx_expand, proportion: 1)

    :wxPanel.setSizer(panel, main_sizer)
    :wxSizer.layout(main_sizer)
    :wxPanel.connect(frame, :paint, [:callback])
    :wxFrame.connect(frame, :command_button_clicked)

    :wxFrame.show(frame)
    loop(frame)
    :wxFrame.destroy(frame)
  end

  def loop(panel) do
    draw(panel)
    receive do
      wx(event: wxClose()) ->
        IO.puts "close_window received"
      event ->
        IO.inspect(event)
        IO.puts "Message received"
        loop(panel)
    end
  end

  def draw(panel) do
    dc = :wxPaintDC.new(panel)
    do_draw(dc)
    :wxPaintDC.destroy(dc)
  end

  def do_draw(dc) do
    IO.puts "do_draw"
    draw_shapes(dc)

    IO.puts "done do_draw"
  end

  def draw_shapes(dc) do
    for r <- (0..3) do
      y = 1 + 3*r
      draw_shapes(dc, r, y)
    end
  end
  def draw_shapes(dc, rotation, y) do
    pen = :wx_const.wx_black_pen
    canvas = :wxGraphicsContext.create(dc)
    :wxGraphicsContext.setPen(canvas, pen)
    IO.inspect 1
    Enum.each(Enum.with_index(Shapes.shapes), fn({{name, shape}, i}) ->
      shape = Enum.at(shape, rotation)
      draw_colored_shape(canvas, name, shape, 1 + 3*i, 2*y)
      IO.inspect 3
    end)
  end

  def draw_shape(canvas, shape, x, y) do
    IO.inspect shape
    # Specify position in 'grid units'
    for {row, row_i} <- Enum.with_index(shape) do
      for {col, col_i} <- Enum.with_index(row) do
        IO.inspect row
        IO.inspect col
        if(col == 1) do
          draw_square(canvas, x + col_i , y + row_i)
        end
      end
    end
  end
  def draw_colored_shape(canvas, brush_name, shape, x, y) do
    brush = brush_for(brush_name)
    :wxGraphicsContext.setBrush(canvas, brush)
    draw_shape(canvas, shape, x, y)
  end

  def draw_square(canvas, x, y) do
    true_x = @side * x
    true_y = @side * y
    :wxGraphicsContext.drawRectangle(canvas, true_x, true_y, @side, @side)
  end

  def brush_for(:bar), do: :wxBrush.new({0, 240, 255, 255})
  def brush_for(:jay), do: :wxBrush.new({12, 0, 255, 255})
  def brush_for(:ell), do: :wxBrush.new({255, 150, 0, 255})
  def brush_for(:ess), do: :wxBrush.new({5, 231, 5, 255})
  def brush_for(:zee), do: :wxBrush.new({255, 17, 17, 255})
  def brush_for(:oh),  do: :wxBrush.new({247, 255, 17, 255})
  def brush_for(:tee), do: :wxBrush.new({100, 255, 17, 255})
end
