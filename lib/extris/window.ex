defmodule Extris.Window do
  @moduledoc """

  For now, Window exists to toy with the options I might have for building out
  a tetris game display using wx in Elixir.

  """

  @title 'ExTris'

  @left 10
  @right 11

  @interval 500

  use Extris.WxImports
  alias Extris.Game.State

  def start(config) do
    :random.seed(:erlang.now)
    do_init(config)
  end

  def init(config) do
    :wx.batch(fn() -> do_init(config) end)
  end

  def do_init(_config) do
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
    :timer.send_interval(@interval, self, :tick)
    Extris.Game.loop(%State{shape: random_shape}, frame)
    :wxFrame.destroy(frame)
  end

  defp random_shape do
    case :random.uniform(7) do
      1 -> :ell
      2 -> :jay
      3 -> :ess
      4 -> :zee
      5 -> :bar
      6 -> :oh
      7 -> :tee
    end
  end
end
