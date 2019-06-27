shader_type canvas_item;

uniform vec4 blue_tint : hint_color;

float fallOff(float r) {
	if (r > 1.0) {
		return 0.0;	
	} else if (r > 0.1) {
		return 1.0 * (pow(1.0 - r, 2));
	} else {
		//return 1.0 - 3.0 * (r * r);
		return 1.0;
	}
}

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	color = mix(color, blue_tint, 0.3);
	float pos_x = UV.x - 0.5;
	
	float pos_y = UV.y - 0.5;
	vec4 result_color = color;
	
	// Compute distance from the circle center
	pos_x = pos_x * pos_x;
	pos_y = pos_y * pos_y;
	
	float distance = pos_x + pos_y;
	distance = sqrt(distance);
	float alpha = fallOff(distance * 2.0);
	result_color.a = clamp(alpha, 0.0, 1.0);
	
	/*
	pos_x = pos_x * pos_x;
	pos_y = pos_y * pos_y;
	
	vec4 result_color;

	if ((pos_x + pos_y) < 0.20) {
		float alpha = 1.0 - (pos_x + pos_y) / 0.20 + 0.3;
		if (alpha > 1.0) {
			alpha = 1.0;	
		}
		result_color = color;
		result_color.a = alpha;
		
	} else {
		result_color = vec4(1.0, 1.0, 1.0, 0.0);	
	}*/
	
	COLOR = result_color;

}