
function Path_var(_my_path, _start_x, _start_y, _xscale = 1, _yscale = 1, _is_circle = false) constructor {
	my_path = _my_path;
	start_x = _start_x;
	start_y = _start_y;
	xscale = _xscale;
	yscale = _yscale;
	is_circle = _is_circle;
	
	static get_path_var = function(){
		return my_path;
	}
	
	static get_path_var_number = function(){
		var number = path_get_number(my_path);
		return number;
	}
	
	static get_path_var_start_x = function(){
		return start_x;
	}
	
	static get_path_var_start_y = function(){
		return start_y;
	}
	
	static get_path_var_point_x = function(index){
		var point_x = path_get_point_x(my_path, index)
		return point_x;
	}
	
	static get_path_var_point_y = function(index){
		var point_y = path_get_point_y(my_path, index)
		return point_y;
	}
	
	static get_path_var_xscale = function(){
		return xscale;
	}
	
	static get_path_var_yscale = function(){
		return yscale;
	}
	
	static get_path_var_form = function(){
		return is_circle;
	}
}

function create_new_path_var(_inst_ref){
	var path_var = noone;
	if(path_exists(_inst_ref)){
		var path_id = _inst_ref;
		var path_start_x = path_get_point_x(path_id, 0);
		var path_start_y = path_get_point_y(path_id, 0);
		path_var = new Path_var(path_id, path_start_x, path_start_y);
	}
	else{
		var path_ref = _inst_ref;
		var path_id = path_ref.get_path_id();
		var path_start_x = path_get_point_x(path_id, 0);
		var path_start_y = path_get_point_y(path_id, 0);
		var path_xscale = path_ref.image_xscale;
		var path_yscale = path_ref.image_yscale;
		var path_is_circle = true;
		path_var = new Path_var(path_id, path_start_x, path_start_y, path_xscale, path_yscale, path_is_circle);
	}
	return path_var
}