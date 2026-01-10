// Inputs do teclado
var right = keyboard_check(ord("D")) or gamepad_button_check(0, gp_padr);
var left = keyboard_check(ord("A")) or gamepad_button_check(0, gp_padl);
var jump = keyboard_check(vk_space) or gamepad_button_check(0, gp_face1);
var jump_pressed = keyboard_check_pressed(vk_space) or gamepad_button_check(0, gp_face1);

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


if(place_meeting(x + x_speed, y, obj_platform_parent)) {
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

var clamp_yspeed = max(0, y_speed);
var list_inst = ds_list_create();
var is_ordered = false;
var list_inst_size = instance_place_list(x, y + 1 + clamp_yspeed + max_grav, list_obj, list_inst, is_ordered);
show_debug_message_list(list_inst);


for(var i = 0; i < list_inst_size; i++){
	var inst_obj = list_inst[| i];
	//show_debug_message(object_get_name(inst_obj.object_index));
	
	// Se for Semisólido (One-Way)
    if (object_is_ancestor(inst_obj.object_index, obj_semisolid) or inst_obj.object_index == obj_semisolid) { 
        // Se estivermos caindo e o bbox_bottom estiver acima do topo da plataforma
        if (y_speed >= 0 and bbox_bottom <= inst_obj.bbox_top) {
            if (!instance_exists(floor_plat) or inst_obj.bbox_top < floor_plat.bbox_top) {
                floor_plat = inst_obj;
            }
        }
    }
    // Se for Sólido (Ground/Slopes)
    else {
        floor_plat = inst_obj;
        
        break; 
    }
}
ds_list_destroy(list_inst);

//if(instance_exists(floor_plat) and object_get_name(floor_plat.object_index) == "obj_semisolid"){show_message("aq");}

// Checando se o player está colidindo com alguma plataforma
if(instance_exists(floor_plat) and !place_meeting(x, y + max_grav, floor_plat)){
	floor_plat = noone;
}




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

function check_on_ground(){
	var y_check = 1;
	if(place_meeting(x, y + y_check, obj_ground) and y_speed >= 0){
		on_ground = true;
	}
	else{
		on_ground = false;
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
