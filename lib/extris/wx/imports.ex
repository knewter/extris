defmodule Extris.Wx.Imports do
  defmacro __using__(_) do
    quote do
      require Record
      Record.defrecordp :wx, Record.extract(:wx, from_lib: "wx/include/wx.hrl")
      Record.defrecordp :wxClose, Record.extract(:wxClose, from_lib: "wx/include/wx.hrl")
      Record.defrecordp :wxCommand, Record.extract(:wxCommand, from_lib: "wx/include/wx.hrl")
      Record.defrecordp :wxKey, Record.extract(:wxKey, from_lib: "wx/include/wx.hrl")
    end
  end
end
