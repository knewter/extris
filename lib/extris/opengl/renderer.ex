defmodule Extris.OpenGL.Renderer do
  @behaviour :wx_object
  alias Extris.Shapes

  require Record
  Record.defrecordp :wx, Record.extract(:wx, from_lib: "wx/include/wx.hrl")
  Record.defrecordp :wxSize, Record.extract(:wxSize, from_lib: "wx/include/wx.hrl")
  Record.defrecordp :wxKey, Record.extract(:wxKey, from_lib: "wx/include/wx.hrl")

  defmodule State do
    defstruct [
      :parent,
      :config,
      :canvas,
      :timer,
      :time,
      :top,
      :xrot,
      :yrot,
      :box,
      :game
    ]
  end

  def start(config) do
    IO.puts "starting"
    :wx_object.start_link(__MODULE__, config, [])
  end

  def init(config) do
    IO.puts "interior init"
    :wx.batch(fn() -> do_init(config) end)
  end

  def do_init(config) do
    IO.puts "do_init"
    parent = :proplists.get_value(:parent, config)
    size = :proplists.get_value(:size, config)
    game = :proplists.get_value(:game, config)
    opts = [size: size, style: :wx_const.wx_sunken_border]
    gl_attrib = [
      attribList: [
        :wx_const.wx_gl_rgba,
        :wx_const.wx_gl_doublebuffer,
        :wx_const.wx_gl_min_red, 8,
        :wx_const.wx_gl_min_green, 8,
        :wx_const.wx_gl_min_blue, 8,
        :wx_const.wx_gl_depth_size, 24, 0
      ]
    ]
    canvas = :wxGLCanvas.new(parent, opts ++ gl_attrib)
    :wxGLCanvas.connect(canvas, :size)
    :wxGLCanvas.connect(canvas, :key_up)
    :wxWindow.hide(parent)
    :wxWindow.reparent(canvas, parent)
    :wxWindow.show(parent)
    :wxGLCanvas.setCurrent(canvas)

    state = %State{
      parent: parent,
      config: config,
      canvas: canvas,
      xrot: 0.0,
      yrot: 0.0,
      game: game
    }

    new_state = setup_gl(state)
    IO.puts "after setup_gl"
    timer = :timer.send_interval(20, self, :update)
    IO.puts "after send_interval"

    {parent, %State{ new_state | timer: timer } }
  end

  def handle_event(wx(event: wxSize(size: {w, h})), state) do
    case w == 0 or h == 0 do
      true -> :skip
      _ ->
        resize_gl_scene(w, h)
    end

    {:noreply, state}
  end

  def handle_event(wx(event: wxKey(keyCode: key_code)), state) do
    wxk_up = :wx_const.wxk_up
    wxk_down = :wx_const.wxk_down
    wxk_left = :wx_const.wxk_left
    wxk_right = :wx_const.wxk_right

    new_state = case key_code do
      ^wxk_up ->
        %State{ state | xrot: state.xrot - 0.2 }
      ^wxk_down ->
        %State{ state | xrot: state.xrot + 0.2 }
      ^wxk_left ->
        %State{ state | yrot: state.yrot - 0.2 }
      ^wxk_right ->
        %State{ state | yrot: state.yrot + 0.2 }
      _ -> state
    end

    {:noreply, new_state}
  end

  def handle_info(:update, state) do
    IO.puts "update"
    new_state = :wx.batch(fn() -> render(state) end)
    {:noreply, new_state}
  end

  def handle_info(:stop, state) do
    :timer.cancel(state.timer)
    try do
      :wxGLCanvas.destroy(state.canvas)
    catch
      error, reason ->
        {error, reason}
    end
    {:stop, :normal, state}
  end

  def handle_call(msg, _from, state) do
    {:reply, :ok, state}
  end

  def code_change(_, _, state) do
    {:stop, :not_yet_implemented, state}
  end

  def terminate(_reason, state) do
    try do
      :wxGLCanvas.destroy(state.canvas)
    catch
      error, reason ->
        {error, reason}
    end
    :timer.cancel(state.timer)
    :timer.sleep(300)
  end

  def resize_gl_scene(width, height) do
    :gl.viewport(0, 0, width, height)
    :gl.matrixMode(:wx_const.gl_projection)
    :gl.loadIdentity
    :glu.perspective(45.0, width/height, 0.1, 100.0)
    :gl.matrixMode(:wx_const.gl_modelview)
    :gl.loadIdentity
  end

  def setup_gl(state) do
    {w, h} = :wxWindow.getClientSize(state.parent)
    resize_gl_scene(w, h)
    new_state = setup_display_lists(state)

    :gl.enable(:wx_const.gl_texture_2d)
    :gl.shadeModel(:wx_const.gl_smooth)
    :gl.clearColor(0.0, 0.0, 0.0, 0.0)
    :gl.clearDepth(1.0)
    :gl.enable(:wx_const.gl_depth_test)
    :gl.depthFunc(:wx_const.gl_lequal)
    :gl.enable(:wx_const.gl_light0)
    :gl.enable(:wx_const.gl_lighting)
    :gl.enable(:wx_const.gl_color_material)
    :gl.hint(:wx_const.gl_perspective_correction_hint, :wx_const.gl_nicest)

    light_ambient = {0.5, 0.5, 0.5, 0.5}
    :gl.lightfv(:wx_const.gl_light1, :wx_const.gl_ambient, light_ambient)

    new_state
  end

  def setup_display_lists(state) do
    box = :gl.genLists(2)
    :gl.newList(box, :wx_const.gl_compile)

    :gl.begin(:wx_const.gl_quads)

    # Front Face
    :gl.texCoord2f(0.0, 0.0); :gl.vertex3f(-1.0, -1.0,  1.0)
    :gl.texCoord2f(1.0, 0.0); :gl.vertex3f( 1.0, -1.0,  1.0)
    :gl.texCoord2f(1.0, 1.0); :gl.vertex3f( 1.0,  1.0,  1.0)
    :gl.texCoord2f(0.0, 1.0); :gl.vertex3f(-1.0,  1.0,  1.0)

    # Back Face
    :gl.texCoord2f(1.0, 0.0); :gl.vertex3f(-1.0, -1.0, -1.0)
    :gl.texCoord2f(1.0, 1.0); :gl.vertex3f(-1.0,  1.0, -1.0)
    :gl.texCoord2f(0.0, 1.0); :gl.vertex3f( 1.0,  1.0, -1.0)
    :gl.texCoord2f(0.0, 0.0); :gl.vertex3f( 1.0, -1.0, -1.0)

    # Top Face
    :gl.texCoord2f(0.0, 1.0); :gl.vertex3f(-1.0,  1.0, -1.0)
    :gl.texCoord2f(0.0, 0.0); :gl.vertex3f(-1.0,  1.0,  1.0)
    :gl.texCoord2f(1.0, 0.0); :gl.vertex3f( 1.0,  1.0,  1.0)
    :gl.texCoord2f(1.0, 1.0); :gl.vertex3f( 1.0,  1.0, -1.0)

    # Bottom Face
    :gl.texCoord2f(1.0, 1.0); :gl.vertex3f(-1.0, -1.0, -1.0)
    :gl.texCoord2f(0.0, 1.0); :gl.vertex3f( 1.0, -1.0, -1.0)
    :gl.texCoord2f(0.0, 0.0); :gl.vertex3f( 1.0, -1.0,  1.0)
    :gl.texCoord2f(1.0, 0.0); :gl.vertex3f(-1.0, -1.0,  1.0)

    # Right Face
    :gl.texCoord2f(1.0, 0.0); :gl.vertex3f( 1.0, -1.0, -1.0)
    :gl.texCoord2f(1.0, 1.0); :gl.vertex3f( 1.0,  1.0, -1.0)
    :gl.texCoord2f(0.0, 1.0); :gl.vertex3f( 1.0,  1.0,  1.0)
    :gl.texCoord2f(0.0, 0.0); :gl.vertex3f( 1.0, -1.0,  1.0)

    # Left Face
    :gl.texCoord2f(0.0, 0.0); :gl.vertex3f(-1.0, -1.0, -1.0)
    :gl.texCoord2f(1.0, 0.0); :gl.vertex3f(-1.0, -1.0,  1.0)
    :gl.texCoord2f(1.0, 1.0); :gl.vertex3f(-1.0,  1.0,  1.0)
    :gl.texCoord2f(0.0, 1.0); :gl.vertex3f(-1.0,  1.0, -1.0)

    :gl.end
    :gl.endList

    %State{ state | box: box }
  end

  def render(state) do
    new_state = draw(state)
    :wxGLCanvas.swapBuffers(state.canvas)
    new_state
  end

  def draw(state) do
    use Bitwise
    :gl.clear(bor(:wx_const.gl_color_buffer_bit, :wx_const.gl_depth_buffer_bit))

    bitmap =
      [
        [ 0, 0, 1, 0, 0 ],
        [ 0, 0, 1, 0, 0 ],
        [ 0, 1, 1, 0, 0 ]
      ]
    draw_bitmap(bitmap, state)

    state
  end

  def draw_bitmap(bitmap, state) do
    for {row, row_num} <- Enum.with_index(bitmap) do
      draw_row({row, row_num}, state)
    end
  end
  def draw_row({row, row_num}, state) do
    IO.puts "drawing row #{row_num} #{inspect row}"
    for {cell, cell_num} <- Enum.with_index(row) do
      draw_cell(row_num, {cell, cell_num}, state)
    end
  end
  def draw_cell(_, {0, _}, _), do: :ok
  def draw_cell(row_num, {cell, cell_num}, state) do
    IO.puts "drawing cell #{row_num} #{cell_num} #{inspect cell}"
    :gl.loadIdentity()
    :gl.translatef(1.4 + (cell_num * 2.2), ((6.0 - row_num) * 2.0) - 7.0, -40.0)
    color = brush_for(cell)
    :erlang.apply(:gl, :color3f, color)
    :gl.callList(state.box)
  end

  def brush_for(n) when is_integer(n) do
    Shapes.by_number(n)
    |> brush_for
  end

  def brush_for(:ell),   do: [1.0, 0.59, 0]
  def brush_for(:jay),   do: [0.05, 0, 1.0]
  def brush_for(:ess),   do: [0.02, 0.91, 5]
  def brush_for(:zee),   do: [1.0, 0.067, 0.067]
  def brush_for(:bar),   do: [0.0, 0.94, 1.0]
  def brush_for(:oh),    do: [0.97, 1.0, 0.067]
  def brush_for(:tee),   do: [0.39, 1.0, 0.067]
  def brush_for(:board), do: [0.0, 0.0, 0.0]
end
