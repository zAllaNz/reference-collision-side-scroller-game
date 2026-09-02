event_inherited();
set_path(my_path);

function set_path(new_path){
	var default_speed = 100;
	var is_smooth = true;
	var is_closed = true;
	path_add_point(new_path, x + sprite_width / 2, y, default_speed);
	path_add_point(new_path, x + sprite_width, y + sprite_height / 2, default_speed);
	path_add_point(new_path, x + sprite_width / 2, y + sprite_height, default_speed);
	path_add_point(new_path, x, y + sprite_height / 2, default_speed);
	path_set_kind(new_path, is_smooth);
	path_set_closed(new_path, is_closed);
}
