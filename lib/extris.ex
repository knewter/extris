defmodule Extris do
  use Application
  @game_interval 500

  def start(_type, _args) do
    {:ok, game} = Extris.Game.start_link
    Process.register(game, :game)
    :timer.send_interval(@game_interval, game, :tick)
    # spawn(fn() -> Extris.Sdl.Window.start(game) end)
    # spawn(fn() -> Extris.Wx.Window.start(game) end)
    # spawn(fn() -> Extris.TTY.Window.start(game) end)
    spawn(fn() ->
      window = Extris.OpenGL.Window.start(game)
      Extris.OpenGL.Window.load(window, Extris.OpenGL.Renderer)
    end)
    Extris.Supervisor.start_link
  end
end
