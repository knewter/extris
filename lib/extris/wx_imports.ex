defmodule Extris.WxImports do
  defmacro __using__(_) do
    quote do
      require Record
      [:wx, :wxClose, :wxCommand, :wxKey]
      |> Enum.each(fn(rec) ->
      Record.defrecordp rec, Record.extract(rec, from_lib: "wx/include/wx.hrl")
      end)
    end
  end
end
