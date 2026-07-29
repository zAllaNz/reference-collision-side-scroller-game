if(my_path == noone and init){
	init = !init;
	my_path = obj_path_controller.get_path();
	path_start(my_path, 1, path_action_continue, true);
}