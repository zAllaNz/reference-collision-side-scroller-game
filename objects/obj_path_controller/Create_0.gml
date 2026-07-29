path_list = ds_list_create();
append_all_paths(path_list);

var path_list_size = ds_list_size(path_list);
for(var i = 0; i < path_list_size; i++){
	var inst_a = path_list[| i];
	var inst_path_a = inst_a.get_path_id();
	for(var j = 0; j < path_list_size; j++){
		var inst_b = path_list[| j];
		var inst_path_b = inst_b.get_path_id();
		if(i == j){
			continue;
		}
		show_message(string(inst_a) + " - " + string(ax) + ";" + string(ay) + " --- " + string(inst_b) + " - " + string(bx) + ";" + string(by));
		if(path_point_adjacent(inst_path_a, inst_path_b)){
			show_message("somos adjacentes!");
		}
	}
}








function append_all_paths(path_list){
	// A ordem de criação dos objetos line importam, sempre checar isso.
	with(obj_path_line_parent){
		show_debug_message(get_path_id());
		ds_list_add(other.path_list, id)
	}
}
	
function path_point_adjacent(path_a, path_b){
	var tol = 2;
	var a_last = path_get_number(path_a) - 1;
	var ax = path_get_point_x(path_a, a_last);
	var ay = path_get_point_y(path_a, a_last);
	var bx = path_get_point_x(path_b, 0);
	var by = path_get_point_y(path_b, 0);
	
	if(point_distance(ax, ay, bx, by) <= tol){
		return true;
	}
	return false
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
