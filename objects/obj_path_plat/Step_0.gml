if(my_path == noone and init){
    my_path = obj_path_controller.get_closest_path(self);
    if(my_path != noone){
		set_new_origin_position(my_path);
		path_action_selected = set_path_action(my_path);
        path_start(my_path, 1, path_action_selected, false);
        init = !init;
    }
}

