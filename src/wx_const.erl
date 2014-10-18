-module(wx_const).
-compile(export_all).

-include_lib("wx/include/wx.hrl").

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
