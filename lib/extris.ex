defmodule Extris do
  use Application

  def start(_type, _args) do
    Extris.Window.start({})
    Extris.Supervisor.start_link
  end
end
