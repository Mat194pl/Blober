shader_type canvas_item;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec2 ps = TEXTURE_PIXEL_SIZE;
	float radius=2.0;
    vec2 pos = UV;

	// Add blur
	color += texture(TEXTURE, pos + vec2(0, -radius)*ps);
	color += texture(TEXTURE, pos + vec2(0, radius)*ps);
	color += texture(TEXTURE, pos + vec2(-radius, 0)*ps);
	color += texture(TEXTURE, pos + vec2(radius, 0)*ps);
	
	color /= 5.0;
	
	float thresh = step(0.3, color.a);
	vec4 result_color = vec4(thresh * 0.7, thresh * 0.9, thresh, thresh);
	
	
	COLOR = result_color;
}