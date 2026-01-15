/// @description Insert description here
// You can write your code in this editor
move_direction = 0;
move_speed = 3.125;
x_speed = 0;
y_speed = 0;
sub_pixel = 0.5;

// Variáveis de gravidade
grav = 0.275;
max_grav = 8;
on_ground = false;

// Variáveis de pulo
jump_speed = -6.615;
jump_buffer_timer = 0;
jump_buffer_frames_max = 3;
jump_buffered = false;
jump_hold_timer = 0;
jump_hold_frames = 10;

// Variáveis de colisão
floor_plat = noone;
list_obj = array_create(0);
array_push(list_obj, obj_platform_parent);

// Debug
debug_y = bbox_bottom;
debug_x = bbox_right - (sprite_width / 2);
debug_width = view_wport;