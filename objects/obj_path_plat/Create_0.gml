my_path = noone;
init = true;
path_action_selected = noone;

function set_new_origin_position(_path){
	var new_x = path_get_point_x(my_path, 0);
	var new_y = path_get_point_y(my_path, 0);
	x = new_x;
	y = new_y;
}

function set_path_action(_path){
	var _len = path_get_number(_path) - 1;
	var _x1 = path_get_point_x(_path, 0);
	var _x2 = path_get_point_x(_path, _len);
	var _y1 = path_get_point_y(_path, 0);
	var _y2 = path_get_point_y(_path, _len);
	
	// Caso a coordenada inicial e a final sejam a mesmas, o path é fechado
	// O path action é definido como continue
	if(_x1 == _x2 and _y1 == _y2){
		return path_action_continue
	}
	return path_action_reverse
}