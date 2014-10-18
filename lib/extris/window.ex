defmodule Extris.Window do
  @moduledoc """

  For now, Window exists to toy with the options I might have for building out
  a tetris game display using wx in Elixir.

  """

  @title 'ExTris'

  require Record
  Record.defrecordp :wx, Record.extract(:wx, from_lib: "wx/include/wx.hrl")
  Record.defrecordp :wxClose, Record.extract(:wxClose, from_lib: "wx/include/wx.hrl")
  Record.defrecordp :wxCommand, Record.extract(:wxCommand, from_lib: "wx/include/wx.hrl")

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
    pen = :wx_const.wx_black_pen
    brush = :wxBrush.new({30, 175, 23, 127})
    canvas = :wxGraphicsContext.create(dc)
    font = :wx_const.wx_italic_font
    :wxGraphicsContext.setPen(canvas, pen)
    :wxGraphicsContext.setBrush(canvas, brush)
    :wxGraphicsContext.setFont(canvas, font, {0, 0, 50})
    :wxGraphicsContext.drawRoundedRectangle(canvas, 35.0, 35.0, 100.0, 50.0, 10.0)
    path = :wxGraphicsContext.createPath(canvas)
    :wxGraphicsPath.addCircle(path, 0.0, 0.0, 40.0)
    :wxGraphicsPath.closeSubpath(path)
    :wxGraphicsContext.translate(canvas, 100.0, 250.0)

    IO.puts "done do_draw"
  end
end
