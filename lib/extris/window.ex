defmodule Extris.Window do
  @moduledoc """

  For now, Window exists to toy with the options I might have for building out
  a tetris game display using wx in Elixir.

  """

  @title 'ExTris'
  @side 25.0

  @left 10
  @right 11

  require Record
  Record.defrecordp :wx, Record.extract(:wx, from_lib: "wx/include/wx.hrl")
  Record.defrecordp :wxClose, Record.extract(:wxClose, from_lib: "wx/include/wx.hrl")
  Record.defrecordp :wxCommand, Record.extract(:wxCommand, from_lib: "wx/include/wx.hrl")
  Record.defrecordp :wxKey, Record.extract(:wxKey, from_lib: "wx/include/wx.hrl")

  alias Extris.Shapes

  defmodule State do
    defstruct shape: :ell, rotation: 0
  end

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
    left = :wxButton.new(frame, @left, label: 'Rotate Left')
    right = :wxButton.new(frame, @right, label: 'Rotate Right')
    :wxSizer.add(main_sizer, left)
    :wxSizer.add(main_sizer, right)
    :wxSizer.add(main_sizer, sizer)
    :wxSizer.add(main_sizer, sizer, flag: :wx_const.wx_expand, proportion: 1)

    :wxPanel.setSizer(panel, main_sizer)
    :wxSizer.layout(main_sizer)
    :wxPanel.connect(frame, :paint, [:callback])
    :wxFrame.connect(frame, :command_button_clicked)
    for action <- [:key_down, :key_up, :char] do
      :wxWindow.connect(frame, action)
    end

    :wxFrame.show(frame)
    loop(%State{}, frame)
    :wxFrame.destroy(frame)
  end

  def loop(state, panel) do
    draw(state, panel)
    receive do
      wx(event: wxClose()) ->
        IO.puts "close_window received"
      wx(id: @left, event: wxCommand(type: :command_button_clicked)) ->
        state = %State{state | rotation: rem(state.rotation - 1, 4)}
        loop(state, panel)
      wx(id: @right, event: wxCommand(type: :command_button_clicked)) ->
        state = %State{state | rotation: rem(state.rotation + 1, 4)}
        loop(state, panel)
      wx(event: wxKey(keyCode: 65)) ->
        state = %State{state | rotation: rem(state.rotation + 1, 4)}
        loop(state, panel)
      wx(event: wxKey(keyCode: 68)) ->
        state = %State{state | rotation: rem(state.rotation - 1, 4)}
        loop(state, panel)
      event ->
        IO.inspect(event)
        IO.puts "Message received"
        loop(state, panel)
    end
  end

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
    draw_colored_shape(canvas, :ell, Enum.at(shape, rotation), 3, 3)
  end

  def draw_shape(canvas, shape, x, y) do
    # Specify position in 'grid units'
    for {row, row_i} <- Enum.with_index(shape) do
      for {col, col_i} <- Enum.with_index(row) do
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

  def handle_key(event=wxKey(keyCode: 65), object) do
    IO.inspect event
    IO.inspect "key pressed"
  end
  def handle_key(event, object) do
    IO.inspect event
    IO.inspect "key pressed"
  end
end
