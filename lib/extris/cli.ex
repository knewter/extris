defmodule Extris.CLI do
  def main(_args) do
    spawn(&init/0)
    :timer.sleep(:infinity)
  end

  def init do
    {:ok, Port.open({:spawn, "tty_sl -c -e"}, [:binary, :eof])}
    loop
  end

  def loop do
    receive do
      {_port, {:data, data}} ->
        translate(data)
        |> handle_key
        loop
      _ ->
        loop
    end
  end

  defp translate("\e[A"), do: :rotate_cw
  defp translate("\e[B"), do: :rotate_ccw
  defp translate("\e[C"), do: :move_right
  defp translate("\e[D"), do: :move_left
  defp translate(_),      do: nil

  defp handle_key(nil), do: :ok
  defp handle_key(key), do: Extris.Game.handle_input(:game, key)
end
