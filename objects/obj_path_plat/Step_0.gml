if(path_reference == noone and init){
    path_reference = obj_path_controller.get_closest_path(self);
    if(path_reference != noone){
		set_new_origin_position(path_reference);
		path_action_selected = set_path_action(path_reference);
		var my_path = path_reference.get_path_var();
        path_start(my_path, 1, path_action_selected, false);
        init = !init;
    }
}

