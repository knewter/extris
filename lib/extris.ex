defmodule Extris do
  @color_black 0
  @color_red 1
  @color_green 2
  @color_blue 4
  @color_magenta 5
  @color_cyan 6
  @color_white 7

  @colors %{
    @color_white: 1,
    @color_blue: 2,
    @color_cyan: 3,
    @color_green: 4,
    @color_magenta: 5,
    @color_red: 6,
    @color_yellow: 7,
    @color_black: 8
  }
  @color_pair_text 9
  @color_pair_over 10

  def go do
    start_curses
    set_up_colors
  end

  defp start_curses do
    :encurses.initscr
    :encurses.cbreak
    :encurses.no_echo
    :encurses.no_nl
    :encurses.curs_set(0)
  end

  defp set_up_colors do
    :encurses.start_color
    for {key, value} <- Enum.to_list(@colors) do
      :encurses.init_pair(value, key, key)
    end
    :encurses.init_pair(@color_pair_text, @color_white, @color_black)
    :encurses.init_pair(@color_pair_over, @color_red, @color_black)
  end
end
