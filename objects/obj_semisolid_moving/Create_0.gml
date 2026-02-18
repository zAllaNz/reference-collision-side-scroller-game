event_inherited();
pos_ini = y;
max_height = pos_ini + 64;
dir = 1
y_speed = 1;

function move(){
	y = clamp(y, pos_ini, max_height);

	if(y >= max_height or y <= pos_ini){
		dir *= -1
	}
}