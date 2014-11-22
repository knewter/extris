defmodule HelloRect do
  def run do
    init
  end

  def init do
    :ok = :sdl.start([:video])
    :ok = :sdl.stop_on_exit()
    {:ok, window} = :sdl_window.create('Hello SDL', 10, 10, 500, 500, [])
    {:ok, renderer} = :sdl_renderer.create(window, 01, [:accelerated, :present_vsync])
    loop(%{window: window, renderer: renderer})
  end

  def loop(state) do
    events_loop
    render(state)
    loop(state)
  end

  def events_loop do
    case :sdl_events.poll do
      false -> :ok
      %{type: :quit} -> terminate
      _ -> events_loop
    end
  end

  def render(%{renderer: renderer}) do
    :ok = :sdl_renderer.set_draw_color(renderer, 255, 255, 255, 255)
    :ok = :sdl_renderer.clear(renderer)
    :ok = :sdl_renderer.set_draw_color(renderer, 255, 0, 0, 255)
    :ok = :sdl_renderer.fill_rect(renderer, %{x: 100, y: 100, w: 50, h: 50})
    :ok = :sdl_renderer.present(renderer)
  end

  def terminate do
    :init.stop
    exit(:normal)
  end
end

HelloRect.run
