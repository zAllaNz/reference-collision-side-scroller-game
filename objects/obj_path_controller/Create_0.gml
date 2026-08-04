path_list = ds_list_create();
append_all_paths(path_list);
path_adjacents = [];
path_adjacents = path_list_adjacent(path_adjacents, path_list);
//show_debug_message(path_adjacents);
group = []
group = group_path_adjacencies(path_adjacents);


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
		for(var j = 0; j < path_list_size; j++){
			var inst_b = path_list[| j];
			var inst_path_b = inst_b.get_path_id();
			//show_debug_message("iteração do j " + string(j));
			if(i == j){
				continue;
			}
			if(path_point_adjacent(inst_path_a, inst_path_b)){
				path_matrix[path_i, 0] = inst_a;
				path_matrix[path_i, 1] = inst_b;
				path_i++;
				break;
			}
			if(j == path_list_size - 1){
				path_matrix[path_i, 0] = inst_a;
				path_matrix[path_i, 1] = noone;
				path_i++;
			}
		}
	}
	ds_list_destroy(path_list);
	return path_matrix
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
    for (var i = 0; i < _n; i++) {
        var pair = adjacency_list[i];
        var inst = pair[0];
        var adj  = pair[1];

        ds_map_add(next_map, inst, adj);

        if (adj != -4) {
            ds_map_add(is_next, adj, true);
        }
    }

    var groups = [];
    for (var i = 0; i < _n; i++) {
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

    for (var i = 0; i < _n; i++) {
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
