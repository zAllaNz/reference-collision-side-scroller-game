// Inputs do teclado
var right = keyboard_check(ord("D"));
var left = keyboard_check(ord("A"));
var up = keyboard_check(ord("W"));
var down = keyboard_check(ord("S"));

// Direcao do personagem de acordo com a tecla pressionada
move_direction = (right - left);
x_speed = move_direction * move_speed;
limit_y_speed();

if(place_meeting(x + x_speed, y, obj_ground)) {
    var inst = collision_line(bbox_left + x_speed, y-10, bbox_right + x_speed, y-10, obj_ground, false, true);
    if (inst != noone) {
        if (x_speed > 0) {
            dist_x = inst.bbox_left - bbox_right;
        } else {
            dist_x = inst.bbox_right - bbox_left;
        }
        x += dist_x;
        x_speed = 0;
    }
}
x += x_speed;



/// DEBUG
debug_y = bbox_bottom;
debug_x = bbox_right - (sprite_width / 2);
debug_width = view_wport;





function limit_y_speed(){
	y_speed = min(y_speed + grav, max_grav);
}