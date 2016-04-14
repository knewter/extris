defmodule Extris.OpenGL.Window do
  @title 'Tetris OpenGL'
  require Record
  Record.defrecordp :wx, Record.extract(:wx, from_lib: "wx/include/wx.hrl")
  Record.defrecordp :wxClose, Record.extract(:wxClose, from_lib: "wx/include/wx.hrl")

  defmodule State do
    defstruct [:win, :object, :game]
  end

  def start(game) do
    :wx_object.start(__MODULE__, game, [])
  end

  def init(game) do
    :wx.new([])
    Process.flag(:trap_exit, true)

    frame = :wxFrame.new(:wx.null, :wx_const.wx_id_any, @title, [size: {1000, 1000}])
    :wxFrame.show(frame)
    {frame, %State{win: frame, game: game}}
  end

  def load(ref, module) do
    :wx_object.call(ref, {:load, module})
  end

  def unload(ref) do
    :wx_object.call(ref, :unload)
  end

  def shutdown(ref) do
    :wx_object.call(ref, :stop)
  end

  def handle_info({:EXIT, _, :wx_deleted}, state) do
    {:noreply, state}
  end
  def handle_info({:EXIT, _, :normal}, state) do
    {:noreply, state}
  end
  def handle_info(msg, state) do
    {:noreply, state}
  end

  def handle_call({:load, module}, _from, state) do
    ref = apply(module, :start, [[parent: state.win, size: :wxWindow.getClientSize(state.win), game: state.game]])
    {:reply, ref, %State{state | object: ref}}
  end
  def handle_call(:unload, _from, state) do
    obj = :wx_object.get_pid(state.object)
    send(obj, :stop)
    {:reply, :ok, %State{state | object: :undefined}}
  end
  def handle_call(:stop, _from, state) do
    {:stop, :normal, state}
  end
  def handle_call(msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_event(wx(event: wxClose()), state) do
    :ok = :wxFrame.setStatusText(state.win, "Closing...", [])
    {:stop, :normal, state}
  end

  def handle_event(ev, state) do
    IO.puts "#{__MODULE__} Event: #{inspect ev}"
    {:noreply, state}
  end

  def code_change(_, _, state) do
    {:stop, :not_yet_implemented, state}
  end

  def terminate(_reason, _state) do
    :wx.destroy
  end
end
