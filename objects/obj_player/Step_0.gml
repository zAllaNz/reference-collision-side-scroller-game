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
//show_debug_message("1:" + string(y_speed));
check_on_ground();
limit_y_speed();
//show_debug_message("2:" + string(y_speed));

if(place_meeting(x + x_speed, y, obj_ground)) {
	var pixel_check = sub_pixel * sign(x_speed);
	// Caso esteja colidindo com um slope
	if(!place_meeting(x + x_speed, y - abs(x_speed) - 1, obj_ground)){
		var y_increment = 1;
		while(place_meeting(x + x_speed, y, obj_ground)){
			y -= y_increment;
		}
	}
	else{
		while(!place_meeting(x + pixel_check, y, obj_ground)){
			x += pixel_check;
		}
		x_speed = 0;
	}
}

if(!place_meeting(x + x_speed, y + 1, obj_ground) and place_meeting(x + x_speed, y + abs(x_speed) + 1, obj_ground) and y_speed >= 0){
	show_debug_message("aq");
	while(!place_meeting(x + x_speed, y + sub_pixel, obj_ground)){
		y += sub_pixel;
	}
}

x += x_speed;

if(place_meeting(x, y + y_speed, obj_ground)){
	var pixel_check = sub_pixel * sign(y_speed);
	while(!place_meeting(x, y + pixel_check, obj_ground)){
		y += pixel_check;
	}
	y = round(y);
	y_speed = 0;
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
