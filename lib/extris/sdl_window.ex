defmodule Extris.SdlWindow do
  @moduledoc """

  Begin an SDL window to render an Extris game

  """

  @title 'ExTris - SDL'

  @game_interval 500
  @refresh_interval 100

  alias Extris.Game

  def start(config) do
    :random.seed(:erlang.now)
    init(config)
  end

  def init(_config) do
    :ok = :sdl.start([:video])
    :ok = :sdl.stop_on_exit()
    {:ok, window} = :sdl_window.create('Hello SDL', 10, 10, 1000, 1000, [])
    {:ok, renderer} = :sdl_renderer.create(window, -1, [:accelerated, :present_vsync])
    {:ok, game} = Game.start_link
    :timer.send_interval(@refresh_interval, self, :tick)
    :timer.send_interval(@game_interval, game, :tick)
    loop(game, renderer)
    :erlang.terminate
  end

  def loop(game, renderer) do
    IO.puts "loop"
    state = Game.get_state(game)
    case :sdl_events.poll do
      false -> :ok
      %{type: :quit} -> :erlang.terminate
      _ -> loop(game, renderer)
    end

    receive do
      :tick ->
        IO.puts "tick"
        Extris.SDL.Renderer.draw(state, renderer)
        loop(game, renderer)
      event ->
        loop(state, renderer)
    end
  end
end
