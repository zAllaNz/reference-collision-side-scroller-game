path_list = ds_list_create();
append_all_paths(path_list);
path_adjacents = [];
path_adjacents = path_list_adjacent(path_adjacents, path_list);
group = []
group = group_path_adjacencies(path_adjacents);
show_debug_message(group);
list_group_path = ds_list_create();
list_group_path = transform_path(group);
show_debug_message_dslist(list_group_path);

function append_all_paths(path_list){
	// A ordem de criação dos objetos line importam, sempre checar isso.
	with(obj_path_line_parent){
		ds_list_add(other.path_list, id)
	}
}
	
function path_list_adjacent(path_matrix, path_list){
    var path_i = 0;
    var path_list_size = ds_list_size(path_list);
    for(var i = 0; i < path_list_size; i++){
        var inst_a = path_list[| i];
        var inst_path_a = inst_a.get_path_id();
        var found = false;

        for(var j = 0; j < path_list_size; j++){
            if(i == j) continue;
            var inst_b = path_list[| j];
            var inst_path_b = inst_b.get_path_id();
            if(path_point_adjacent(inst_path_a, inst_path_b)){
                path_matrix[path_i, 0] = inst_a;
                path_matrix[path_i, 1] = inst_b;
                path_i++;
                found = true;
                break;
            }
        }

        if(!found){
            path_matrix[path_i, 0] = inst_a;
            path_matrix[path_i, 1] = noone;
            path_i++;
        }
    }
    ds_list_destroy(path_list);
    return path_matrix;
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

/// @function group_path_adjacencies(adjacency_list)
/// @param {Array} adjacency_list  array de pares [instancia, proximo_ou_-4]
/// @return {Array} array de arrays, cada um representando um grupo de paths adjacentes
function group_path_adjacencies(adjacency_list) {
    var next_map = ds_map_create();
    var is_next  = ds_map_create();
    var visited  = ds_map_create();

    var n = array_length(adjacency_list);
    for (var i = 0; i < n; i++) {
        var pair = adjacency_list[i];
        var inst = pair[0];
        var adj  = pair[1];

        ds_map_add(next_map, inst, adj);

        if (adj != -4) {
            ds_map_add(is_next, adj, true);
        }
    }

    var groups = [];
    for (var i = 0; i < n; i++) {
        var inst = adjacency_list[i][0];

        if (ds_map_exists(is_next, inst)) continue;
        if (ds_map_exists(visited, inst)) continue;

        var chain = [];
        var current = inst;
        while (current != -4) {
            array_push(chain, current);
            ds_map_set(visited, current, true);
            current = ds_map_find_value(next_map, current);
        }

        array_push(groups, chain);
    }

    for (var i = 0; i < n; i++) {
        var inst = adjacency_list[i][0];

        if (ds_map_exists(visited, inst)) continue;

        var chain = [];
        var current = inst;
        var start = inst;

        do {
            array_push(chain, current);
            ds_map_set(visited, current, true);
            current = ds_map_find_value(next_map, current);
        } until (current == start || current == -4);

        array_push(groups, chain);
    }

    ds_map_destroy(next_map);
    ds_map_destroy(is_next);
    ds_map_destroy(visited);

    return groups;
}

function transform_path(ref_group){
	var group_path = ds_list_create();
	var ref_group_size = array_length(ref_group);
	for(var i = 0; i < ref_group_size; i++){
		var list_group_size = array_length(ref_group[i]);
		var _path = path_add();
		path_set_kind(_path, 1);
		for(var j = 0; j < list_group_size; j++){
			var path_i = ref_group[i][j].get_path_id()
			path_append(_path, path_i);
		}
		path_set_closed(_path, false);
		ds_list_add(group_path, _path);
	}
	return group_path
}
	
function get_closest_path(object){
	var x_obj = object.x;
	var y_obj = object.y;
	var size = ds_list_size(list_group_path);
	var tol = 8;
	for(var i = 0; i < size; i++){
		var _path = list_group_path[| i];
		var len_points = path_get_number(_path);
		for(var j = 0; j < len_points; j++){
			var x_point = path_get_point_x(_path, j);
			var y_point = path_get_point_y(_path, j);
			if(point_distance(x_obj, y_obj, x_point, y_point) <= tol){
				return _path;
			}
		}
	}
	return noone;
}