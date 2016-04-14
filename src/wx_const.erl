-module(wx_const).
-compile(export_all).

-include_lib("wx/include/wx.hrl").
-include_lib("wx/include/gl.hrl").
-include_lib("wx/include/glu.hrl").

wx_horizontal() ->
    ?wxHORIZONTAL.

wx_vertical() ->
    ?wxVERTICAL.

wx_expand() ->
    ?wxEXPAND.

wx_all() ->
    ?wxALL.

wx_black_pen() ->
    ?wxBLACK_PEN.

wx_full_repaint_on_resize() ->
    ?wxFULL_REPAINT_ON_RESIZE.

wx_italic_font() ->
    ?wxITALIC_FONT.


wx_id_any() ->
    ?wxID_ANY.

wx_sunken_border() ->
    ?wxSUNKEN_BORDER.

wx_gl_rgba() ->
    ?WX_GL_RGBA.

wx_gl_doublebuffer() ->
    ?WX_GL_DOUBLEBUFFER.

wx_gl_min_red() ->
    ?WX_GL_MIN_RED.

wx_gl_min_green() ->
    ?WX_GL_MIN_GREEN.

wx_gl_min_blue() ->
    ?WX_GL_MIN_BLUE.

wx_gl_depth_size() ->
    ?WX_GL_DEPTH_SIZE.

gl_projection() ->
    ?GL_PROJECTION.

gl_modelview() ->
    ?GL_MODELVIEW.

gl_smooth() ->
    ?GL_SMOOTH.

gl_depth_test() ->
    ?GL_DEPTH_TEST.

gl_lequal() ->
    ?GL_LEQUAL.

gl_perspective_correction_hint() ->
    ?GL_PERSPECTIVE_CORRECTION_HINT.

gl_nicest() ->
    ?GL_NICEST.

gl_color_buffer_bit() ->
    ?GL_COLOR_BUFFER_BIT.

gl_depth_buffer_bit() ->
    ?GL_DEPTH_BUFFER_BIT.

gl_triangles() ->
    ?GL_TRIANGLES.

gl_quads() ->
    ?GL_QUADS.

gl_texture_2d() ->
    ?GL_TEXTURE_2D.

gl_texture_mag_filter() ->
    ?GL_TEXTURE_MAG_FILTER.

gl_texture_min_filter() ->
    ?GL_TEXTURE_MIN_FILTER.

gl_linear() ->
    ?GL_LINEAR.

gl_unsigned_byte() ->
    ?GL_UNSIGNED_BYTE.

gl_rgb() ->
    ?GL_RGB.

gl_rgba() ->
    ?GL_RGBA.

gl_lighting() ->
    ?GL_LIGHTING.

wxk_up() ->
    ?WXK_UP.

wxk_down() ->
    ?WXK_DOWN.

wxk_left() ->
    ?WXK_LEFT.

wxk_right() ->
    ?WXK_RIGHT.

gl_ambient() ->
    ?GL_AMBIENT.

gl_diffuse() ->
    ?GL_DIFFUSE.

gl_position() ->
    ?GL_POSITION.

gl_nearest() ->
    ?GL_NEAREST.

gl_linear_mipmap_nearest() ->
    ?GL_LINEAR_MIPMAP_NEAREST.

gl_light1() ->
    ?GL_LIGHT1.

gl_light0() ->
    ?GL_LIGHT0.

gl_color_material() ->
    ?GL_COLOR_MATERIAL.

gl_compile() ->
    ?GL_COMPILE.
