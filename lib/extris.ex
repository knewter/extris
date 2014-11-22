defmodule Extris do
  use Application

  def start(_type, _args) do
    #spawn(fn() -> Extris.Window.start({}) end)
    Extris.Supervisor.start_link
  end
end
