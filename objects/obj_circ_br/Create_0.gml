event_inherited();
set_path(my_path);

function set_path(new_path){
	var default_speed = 100;
	var is_smooth = true;
	path_set_kind(my_path, is_smooth);
	path_set_closed(my_path, false);
	path_add_point(my_path, x, y, default_speed);
	path_add_point(my_path, x + sprite_width, y, default_speed);
	path_add_point(my_path, x + sprite_width, y + sprite_height, default_speed);
}