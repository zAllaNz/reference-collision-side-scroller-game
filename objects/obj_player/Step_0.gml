// Inputs do teclado
var right = keyboard_check(ord("D"));
var left = keyboard_check(ord("A"));
var up = keyboard_check(ord("W"));
var down = keyboard_check(ord("S"));
var jump = keyboard_check(vk_space);
var jump_pressed = keyboard_check_pressed(vk_space);

// Direcao do personagem de acordo com a tecla pressionada
move_direction = (right - left);
x_speed = move_direction * move_speed;

#region // Pulo player --- Fazer uma função no create.

// Caso o player pule, terá um tempo para armazenar um próximo input do pulo.
if(jump_pressed){
	jump_buffer_timer = jump_buffer_frames_max;
}
if(jump_buffer_timer > 0){
	jump_buffered = true;
	jump_buffer_timer--;
}
else{
	jump_buffered = false;
}
// Buffer do pulo, caso esteja no chão o player pulará novamente.
if(jump_buffered and on_ground){
	jump_hold_timer = jump_hold_frames;
}
// Cortar o pulo caso o botão não esteja pressionado.
if(!jump){
	jump_hold_timer = 0;
}
else if(jump_hold_timer > 0){
	y_speed = jump_speed;
	jump_hold_timer--;
	// Parar o pulo caso o player colida com um objeto.
	if(place_meeting(x, y + y_speed, obj_ground)){
		jump_hold_timer = 0;
	}
}
#endregion

check_on_ground();
limit_y_speed();

if(place_meeting(x + x_speed, y, obj_ground)) {
	var is_precision = false; var is_notme = true;
	var _x1 = min(bbox_left, bbox_left + x_speed);
	var _x2 = max(bbox_right, bbox_right + x_speed);
    var inst = collision_rectangle(_x1, bbox_top, _x2, bbox_bottom, obj_ground, is_precision, is_notme);
    if (inst != noone) {
		var dist_x = 0;
        if (x_speed > 0) {
            dist_x = inst.bbox_left - bbox_right;
        } 
		else {
            dist_x = inst.bbox_right - bbox_left;
        }
        x += dist_x;
        x_speed = 0;
    }
}
x += x_speed;

if(place_meeting(x, y + y_speed, obj_ground)){
	var is_precision = false; var is_notme = true;
	var _y1 = min(bbox_top, bbox_top + y_speed);
	var _y2 = max(bbox_bottom, bbox_bottom + y_speed);
	var inst = collision_rectangle(bbox_left, _y1, bbox_right, _y2, obj_ground, is_precision, is_notme);
	if(inst != noone){
		var dist_y = 0;
		if(y_speed > 0){
			dist_y = inst.bbox_top - bbox_bottom;
		}
		else if(y_speed < 0){
			dist_y = inst.bbox_bottom - bbox_top;
		}
		y += dist_y;
		y_speed = 0;
	}
}
y += y_speed;


/// DEBUG
debug_y = bbox_bottom;
debug_x = bbox_right - (sprite_width / 2);
debug_width = view_wport;

function limit_y_speed(){
	if(!on_ground){
		y_speed = min(y_speed + grav, max_grav);
	}
}

function check_on_ground(){
	var y_check = 1;
	if(place_meeting(x, y + y_check, obj_ground) and y_speed >= 0){
		on_ground = true;
	}
	else{
		on_ground = false;
	}
}
