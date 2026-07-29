path_groups = ds_list_create();
path_test = path_add();

// A ordem de criação dos objetos line importam, sempre checar isso.
with(obj_path_line_parent){
	path_append(other.path_test, my_path);
}

function get_path(){
	return path_test
}