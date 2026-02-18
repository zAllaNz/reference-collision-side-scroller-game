// Inputs do teclado
var right = keyboard_check(ord("D")) or gamepad_button_check(0, gp_padr);
var left = keyboard_check(ord("A")) or gamepad_button_check(0, gp_padl);
var up = keyboard_check(ord("W"));
var down_pressed = keyboard_check_pressed(ord("S"));
var jump = keyboard_check(vk_space) or gamepad_button_check(0, gp_face1);
var jump_pressed = keyboard_check_pressed(vk_space) or gamepad_button_check(0, gp_face1);

// Direcao do personagem de acordo com a tecla pressionada
move_direction = (right - left);
x_speed = move_direction * move_speed;
var xrest = frac(x_speed);
var subpixelx_increment = abs(xrest);
move_hspd = x_speed - xrest;

#region // Pulo player --- Fazer uma função no create.

if(instance_exists(floor_plat)){
	if(down_pressed and (floor_plat.object_index == obj_semisolid or object_is_ancestor(floor_plat.object_index, obj_semisolid))){
		floor_plat = noone;
		y += 1;
	}
}

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
	if(place_meeting(x, y + move_vspd, obj_ground)){
		jump_hold_timer = 0;
	}
}
#endregion

check_on_ground();
limit_y_speed();

// Subpixel em y, testando para saber se resolve os bugs
// TODO: refinar a lógica de movimentação no eixo vertical. A lógica está um pouco bagunçada, pensar em como otimizar e remover algumas variáveis, como por exemplo "y_speed".
var yrest = frac(y_speed);
var subpixely_increment = abs(yrest);
move_vspd = y_speed - yrest;
subpixel_accumulator(subpixelx_increment, subpixely_increment);

//show_debug_message(string(move_vspd) + " " + string(yrest) + " subpixel: " + string(subpixely) + " y: " + string(y_speed));
//show_debug_message(string(move_hspd) + " " + string(xrest) + " subpixel: " + string(subpixelx) + "y: " + string(y_speed));
//COLISÃO HORIZONTAL
if(move_hspd != 0){
	var pixel_check = sign(move_hspd);
	var one_pixel = 1;
	var slopes = [obj_slope, obj_semisolid_slope]
	
	//Subir a slope
	if(place_meeting(x + move_hspd, y, slopes) and !place_meeting(x + move_hspd, y - abs(move_hspd), slopes) and !place_meeting(x, y, obj_semisolid_slope)){
		while(place_meeting(x + move_hspd, y, slopes) and !place_meeting(x + sign(move_hspd), y - one_pixel, obj_ground)){
			y--;
		}
	}
	//Descer a slope
	else if(place_meeting(x + move_hspd, y + abs(move_hspd) + one_pixel, obj_ground)){
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

var clamp_yspeed = max(0, move_vspd);
var list_inst = ds_list_create();
var is_ordered = true;
var list_inst_size = instance_place_list(x, y + 1 + clamp_yspeed + max_grav, list_obj, list_inst, is_ordered);
//show_debug_message_list(list_inst);
for(var i = 0; i < list_inst_size; i++){
	var inst_obj = list_inst[| i];
	var inst_name = inst_obj.object_index;
	var one_pixel = 1;
	if(move_vspd >= 0){
		//TODO: Refatorar todo o sistema de collision detector.
		
		//Se minha instância é parent da classe slope ou for o slope, verificar se só tenho colisão com essa instância.
		if(object_is_ancestor(inst_name, obj_slope) or inst_name == obj_slope){
			if(place_meeting(x, y + one_pixel, inst_obj)){
				var aux_list = ds_list_create();
				var aux_len = instance_place_list(x, y + one_pixel, list_obj, aux_list, false);
				if(aux_len == 1){
					floor_plat = inst_obj;
				}
				ds_list_destroy(aux_list);
			}
		}
		//Se o personagem está colidindo com uma slope semisolida.
		else if((inst_name == obj_semisolid_slope or object_is_ancestor(inst_name, obj_semisolid_slope)) 
		and bbox_bottom <= inst_obj.bbox_bottom){
			if(!place_meeting(x, y, obj_semisolid_slope) and !place_meeting(x, y + one_pixel, obj_ground)){
				floor_plat = inst_obj;
			}
		}
		//Se o personagem está colidindo com um objeto semisolido e está acima dele.
		else if(inst_name == obj_semisolid and bbox_bottom <= inst_obj.bbox_top){
			floor_plat = inst_obj;
		}
		//Se o personagem está colidindo com um objeto semisolido e está acima dele.
		else if(inst_name == obj_semisolid_moving and bbox_bottom <= inst_obj.bbox_top){
			floor_plat = inst_obj;
		}
		//Se minha instância é da classe obj_ground.
		else if(inst_name == obj_ground){
			if(place_meeting(x, y + one_pixel, inst_obj)){
				floor_plat = inst_obj;
			}
		}
		//if(instance_exists(floor_plat)){show_message(floor_plat)}
	}
}
ds_list_destroy(list_inst);

if(instance_exists(floor_plat) and !place_meeting(x, y + clamp_yspeed + move_vspd + 1, floor_plat) and move_speed >= 0){
	floor_plat = noone;
}

//COLISÃO VERTICAL
if(instance_exists(floor_plat)){
	var one_pixel = 1;
	while(!place_meeting(x, y + one_pixel, floor_plat))
	{
		y += one_pixel;
	}
	move_vspd = 0;
	y_speed = 0;
}
else{
	if(place_meeting(x, y + move_vspd, obj_ground)){
		var pixel_check = sign(move_vspd);
		while(!place_meeting(x, y + pixel_check, obj_ground)){
			y += pixel_check
		}
		move_vspd = 0;
		y_speed = 0;
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

function subpixel_accumulator(x_increment, y_increment){
	// Eixo horizontal
	if(move_hspd != 0){
		subpixelx += x_increment;
	}
	else{
		subpixelx = 0;
	}
	if(subpixelx >= 1){
		move_hspd += sign(x_speed);
		subpixelx--;
	}
	// Eixo vertical
	if(move_vspd != 0){
		subpixely += y_increment;
	}
	else{
		subpixely = 0;
	}
	if(subpixely >= 1){
		move_vspd += sign(y_speed);
		subpixely--;
	}
}


// TODO: arrumar função check_on_ground, precisa detectar as plataformas e slopes precisamente para resolver a variável "on_ground"
function check_on_ground(){
	var y_check = 1;
	if(place_meeting(x, y + y_check, floor_plat) and move_vspd >= 0){
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
