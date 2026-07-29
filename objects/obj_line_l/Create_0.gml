event_inherited();
set_path(my_path);

function set_path(new_path){
	var default_speed = 100;
	path_add_point(my_path, x + sprite_width, y, default_speed);
	path_add_point(my_path, x, y, default_speed);
}