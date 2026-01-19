
// Inputs do teclado
var right = keyboard_check(ord("D")) or gamepad_button_check(0, gp_padr);
var left = keyboard_check(ord("A")) or gamepad_button_check(0, gp_padl);
var jump = keyboard_check(vk_space) or gamepad_button_check(0, gp_face1);
var jump_pressed = keyboard_check_pressed(vk_space) or gamepad_button_check(0, gp_face1);

// Direcao do personagem de acordo com a tecla pressionada
move_direction = (right - left);
x_speed = move_direction * move_speed;
var xrest = frac(x_speed);
var subpixelx_increment = abs(xrest);
move_hspd = x_speed - xrest;




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
subpixel_accumulator(subpixelx_increment);

// Subpixel em y, testando para saber se resolve os bugs
var yrest = frac(y_speed);
var subpixely_increment = abs(yrest);
move_vspd = y_speed - yrest;

if(move_vspd != 0){
	subpixely += subpixely_increment;
}
else{
	subpixely = 0;
}
if(subpixely >= 1){
	move_vspd += sign(y_speed);
	subpixely--;
}

show_debug_message(string(move_vspd) + " " + string(yrest) + " subpixel: " + string(subpixely) + " y: " + string(y_speed));
//show_debug_message(string(move_hspd) + " " + string(xrest) + " subpixel: " + string(subpixelx) + "y: " + string(y_speed));
//COLISÃO HORIZONTAL
if(move_hspd != 0){
	var pixel_check = sign(move_hspd);
	var one_pixel = 1;
	
	//Subir a slope
	if((place_meeting(x + sign(move_hspd), y, obj_ground) or place_meeting(x + sign(move_hspd) + pixel_check, y, obj_ground)) 
	and !place_meeting(x + sign(move_hspd), y - one_pixel, obj_ground)){
		for(var i = 1; i <= abs(move_hspd); i++){
			if(place_meeting(x + (sign(move_hspd) * i), y, obj_ground) and !place_meeting(x + sign(move_hspd), y - 1, obj_ground)){
				y--;
			}
		}
	}
	//Descer a slope
	else if(!place_meeting(x + move_hspd, y, obj_ground) and place_meeting(x + move_hspd, y + abs(move_hspd) + one_pixel, obj_ground) and move_vspd >= 0){
		while(!place_meeting(x + move_hspd, y + one_pixel, obj_ground)){
			y++;
		}
	}
	//Colidir caso haja alguma plataforma sólida.
	if(place_meeting(x + move_hspd + pixel_check, y, obj_ground)){
		while(!place_meeting(x + pixel_check, y, obj_ground)){
			x += pixel_check;
		}
		move_hspd = 0;
	}
}
x += move_hspd;

//Colisão horizontal antiga
/*
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

if(!place_meeting(x + x_speed, y + 1, obj_ground) and 
	place_meeting(x + x_speed, y + abs(x_speed) + 1, obj_ground) and y_speed >= 0){
	var i = 0;
	x = floor(x);
	x_speed = floor(x_speed);
	while(!place_meeting(x + x_speed, y + 1, obj_ground)){
		y += 1;
	}
}
x += x_speed;
*/

// COLISÃO VERTICAL
/*
if(place_meeting(x, y + y_speed, obj_ground)){
	var pixel_check = 1 * sign(y_speed);
	while(!place_meeting(x, y + pixel_check, obj_ground)){
		y += pixel_check;
	}
	y = round(y);
	y_speed = 0;
}
y += y_speed;
*/

var clamp_yspeed = max(0, move_vspd);
var list_inst = ds_list_create();
var is_ordered = false;
var list_inst_size = instance_place_list(x, y + 1 + clamp_yspeed + max_grav, list_obj, list_inst, is_ordered);
show_debug_message_list(list_inst);
for(var i = 0; i < list_inst_size; i++){
	var inst_obj = list_inst[| i];
	var inst_name = inst_obj.object_index;
	var one_pixel = 1;
	if(move_vspd >= 0){
		//Quando há colisão com um único objeto, então esse objeto será a floor_plat.
		if(i + 1 == list_inst_size and i == 0){
			floor_plat = inst_obj;
		}
		//Se minha instância é parent da classe slope ou for o slope, verificar se só tenho colisão com essa instância.
		else if(object_is_ancestor(inst_name, obj_slope) or inst_name == obj_slope){
			if(place_meeting(x, y + one_pixel, inst_obj)){
				var aux_list = ds_list_create();
				var aux_len = instance_place_list(x, y + one_pixel, list_obj, aux_list, false);
				if(aux_len == 1){
					show_debug_message("estou em alguma slope!!!");
					floor_plat = inst_obj;
				}
				ds_list_destroy(aux_list);
			}
		}
		//Se minha instância é da classe obj_ground.
		else if(inst_name == obj_ground){
			if(place_meeting(x, y + one_pixel, inst_obj)){
				show_debug_message("estou na obj_ground");
				floor_plat = inst_obj;
			}
		}
	}
}
ds_list_destroy(list_inst);

if(instance_exists(floor_plat) and !place_meeting(x, y + move_vspd, floor_plat)){
	floor_plat = noone;
}

//COLISÃO VERTICAL
//TODO: Adicionar subpixel accumulator para o y_speed também.
if(instance_exists(floor_plat)){
	var one_pixel = 1;
	while(!place_meeting(x, y + one_pixel, floor_plat))
	{
		y += one_pixel;
	}
	y = floor(y);
	move_vspd = 0;
	y_speed = 0;
}
else{
	if(place_meeting(x, y - abs(move_vspd), obj_ground)){
		var one_pixel = 1;
		while(!place_meeting(x, y - one_pixel, obj_ground)){
			y -= one_pixel
		}
		move_vspd = 0;
	}
}
y += move_vspd;

/// DEBUG
debug_y = bbox_bottom;
debug_x = bbox_right - (sprite_width / 2);
debug_width = view_wport;

/// Função para limitar o Y Speed do objeto caso ele não esteja em contado com o chão.
function limit_y_speed(){
	if(!on_ground){
		y_speed = min(y_speed + grav, max_grav);
	}
}

function subpixel_accumulator(subpixel_increment){
	if(move_hspd != 0){
		subpixelx += subpixel_increment;
	}
	else{
		subpixelx = 0;
	}
	if(subpixelx >= 1){
		move_hspd += sign(x_speed);
		subpixelx--;
	}
}

// TODO: arrumar função check_on_ground, precisa detectar as plataformas e slopes precisamente para resolver a variável "on_ground"
function check_on_ground(){
	var y_check = 1;
	if((place_meeting(x, y + y_check, floor_plat)) and move_vspd >= 0){
		on_ground = true;
	}
	else{
		on_ground = false;
		floor_plat = noone;
	}
}

function show_debug_message_list(list){
	var txt = "[";
	var len = ds_list_size(list);
	for(i = 0; i < len; i++){
		txt += string(ds_list_find_value(list, i));
	    if (i < len - 1) txt += ", ";
	}
	txt += "]";
	show_debug_message(txt);
}
