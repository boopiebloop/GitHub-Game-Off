shader_type canvas_item;

varying vec2 local_position;
uniform float min_y = -100;
uniform float max_y = 100;
uniform float fill_percentage : hint_range(0.0, 1.0) = 0.5;
uniform vec4 fill_color : source_color;

void vertex() {
	local_position = VERTEX;
}

void fragment() {
	vec4 base = texture(TEXTURE, UV) * COLOR;
	float total_height = max_y - min_y;
	float relative_y = local_position.y - min_y;
	float y_fill_threshold = max_y - (fill_percentage * total_height);
	if (local_position.y >= y_fill_threshold){
		COLOR = fill_color;
	}else{
		COLOR = base;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
