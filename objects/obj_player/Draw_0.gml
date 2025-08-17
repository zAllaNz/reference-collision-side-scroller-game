draw_self();
draw_set_color(c_red);
var _x1 = min(bbox_left, bbox_left + x_speed);
var _x2 = max(bbox_right, bbox_right + x_speed);
var _y1 = min(bbox_top, bbox_top + y_speed);
var _y2 = max(bbox_bottom, bbox_bottom + y_speed);
draw_rectangle(_x1, _y1, _x2 - 1, _y2 - 1, true);
draw_set_color(c_white);
