my_path = path_add();

function set_path(new_path){
	var default_speed = 100;
	path_add_point(new_path, x, y, default_speed);
	path_add_point(new_path, x + sprite_width, y, default_speed);
}

function get_path_lenght(){
	return path_get_number(my_path);
}

function get_path_id(){
	return my_path
}