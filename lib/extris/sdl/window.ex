defmodule Extris.Sdl.Window do
  @moduledoc """

  Begin an SDL window to render an Extris game

  """

  @title 'ExTris - SDL'

  @refresh_interval 100

  alias Extris.Game

  def start(game) do
    :random.seed(:erlang.now)
    init(game)
  end

  def init(game) do
    :ok = :sdl.start([:video])
    :ok = :sdl.stop_on_exit()
    {:ok, window} = :sdl_window.create(@title, 10, 10, 1000, 1000, [])
    {:ok, renderer} = :sdl_renderer.create(window, -1, [:accelerated, :present_vsync])
    :timer.send_interval(@refresh_interval, self, :tick)
    loop(game, renderer)
    :erlang.terminate
  end

  def loop(game, renderer) do
    state = Game.get_state(game)
    case :sdl_events.poll do
      false -> :ok
      %{type: :quit} -> :erlang.terminate
      _ -> loop(game, renderer)
    end

    receive do
      :tick ->
        Extris.SDL.Renderer.draw(state, renderer)
        loop(game, renderer)
      event ->
        loop(state, renderer)
    end
  end
end
