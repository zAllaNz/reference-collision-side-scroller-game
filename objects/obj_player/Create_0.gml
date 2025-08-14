/// @description Insert description here
// You can write your code in this editor
move_direction = 0;
move_speed = 3.25;
x_speed = 0;
y_speed = 0;
subpixel = 0.5;
dist_x = 0;

// Variáveis de gravidade
grav = 0.275;
max_grav = 8;

// Horizontal
debug_y = bbox_bottom;
debug_x = bbox_right - (sprite_width / 2);
debug_width = view_wport;