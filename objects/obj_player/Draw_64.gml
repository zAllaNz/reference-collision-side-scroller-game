/// @description Insert description here
// You can write your code in this editor
draw_set_font(fnt_arial_12);
draw_text(0, 0, "x:" + string(debug_x));
draw_text(0, 80, "move_vspd:" + string(move_vspd));
draw_text(0, 20, "y:" + string(debug_y));
draw_text(0, 40, "On ground:" + string(on_ground));
if(instance_exists(floor_plat)){draw_text(0, 60, "Floor platform:" + string(object_get_name(floor_plat.object_index)));}else{draw_text(0, 60, "Floor platform:noone");}
draw_set_color(c_white);