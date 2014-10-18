defmodule Extris.Window do
  @moduledoc """

  For now, Window exists to toy with the options I might have for building out
  a tetris game display using wx in Elixir.

  """

  @title 'ExTris'
  @side 50.0

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
    draw_ell(dc)

    IO.puts "done do_draw"
  end

  def draw_ell(dc) do
    pen = :wx_const.wx_black_pen
    brush = :wxBrush.new({30, 175, 23, 127})
    canvas = :wxGraphicsContext.create(dc)
    font = :wx_const.wx_italic_font
    :wxGraphicsContext.setPen(canvas, pen)
    :wxGraphicsContext.setBrush(canvas, brush)
    :wxGraphicsContext.setFont(canvas, font, {0, 0, 50})
    draw_shape(canvas, Shapes.shapes.ell, 3, 3)
  end

  def draw_shape(canvas, shape, x, y) do
    # Specify position in 'grid units'
    for {row, row_i} <- Enum.with_index(shape |> hd) do
      for {col, col_i} <- Enum.with_index(row) do
        IO.inspect row
        IO.inspect col
        if(col == 1) do
          draw_square(canvas, x + col_i , y + row_i)
        end
      end
    end
  end

  def draw_square(canvas, x, y) do
    true_x = @side * x
    true_y = @side * y
    :wxGraphicsContext.drawRectangle(canvas, true_x, true_y, @side, @side)
  end
end
