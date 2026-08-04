if(my_path == noone and init){
    my_path = obj_path_controller.get_closest_path(self);
    if(my_path != noone){
        path_start(my_path, 1, path_action_reverse, false);
        init = !init;
    }
}