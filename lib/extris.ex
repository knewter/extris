defmodule Extris do
  use Application
  alias Extris.Game
  @game_interval 500

  def start(_type, _args) do
    {:ok, game} = Game.start_link
    :timer.send_interval(@game_interval, game, :tick)
    spawn(fn() -> Extris.Window.start(game) end)
    spawn(fn() -> Extris.SdlWindow.start(game) end)
    Extris.Supervisor.start_link
  end
end
