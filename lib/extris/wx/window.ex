defmodule Extris.Wx.Window do
  @moduledoc """

  For now, Window exists to toy with the options I might have for building out
  a tetris game display using wx in Elixir.

  """

  @title 'ExTris'

  @left 10
  @right 11

  @refresh_interval 100

  use Extris.Wx.Imports
  alias Extris.Game

  def start(game) do
    :random.seed(:erlang.now)
    do_init(game)
  end

  def init(game) do
    :wx.batch(fn() -> do_init(game) end)
  end

  def do_init(game) do
    wx = :wx.new
    frame = :wxFrame.new(wx, -1, @title, size: {1000,1000})
    panel = :wxPanel.new(frame)
    main_sizer = :wxBoxSizer.new(:wx_const.wx_vertical)
    sizer = :wxStaticBoxSizer.new(:wx_const.wx_vertical, panel, label: "Extris")
    canvas = :wxPanel.new(panel, style: :wx_const.wx_full_repaint_on_resize, size: {1000,1000})
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
    :timer.send_interval(@refresh_interval, self, :tick)
    loop(game, frame)
    :wxFrame.destroy(frame)
  end

  def loop(game, panel) do
    state = Game.get_state(game)
    receive do
      wx(event: wxClose()) ->
        Game.stop(game)
        IO.puts "close_window received"
      :tick ->
        Extris.Wx.Renderer.draw(state, panel)
        loop(game, panel)
      other_event = wx() ->
        Game.handle_input(game, Extris.Wx.Interaction.create_game_event(other_event))
        loop(game, panel)
      event ->
        IO.inspect(event)
        IO.puts "Message received"
        loop(state, panel)
    end
  end
end
