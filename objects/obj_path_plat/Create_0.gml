path_reference = noone;
init = true;
path_action_selected = noone;

function set_new_origin_position(_path){
	var new_x = _path.get_path_var_start_x();
	var new_y = _path.get_path_var_start_y();
	if(_path.get_path_var_form()){
		x = new_x + 18 * _path.get_path_var_xscale();
		y = new_y + 18 * _path.get_path_var_yscale();
	}
	else{
		x = new_x;
		y = new_y;
	}
}

function set_path_action(_path_ref){
	var _path = _path_ref.get_path_var();
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
	if(_path_ref.get_path_var_form()){
		return path_action_continue
	}
	return path_action_reverse
}