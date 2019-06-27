shader_type canvas_item;

float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(12.9898, 78.233)))* 43758.5453123);
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	// 4 corners of a rectangle surrounding our point
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));
	vec2 cubic = f * f * (3.0 - 2.0 * f);
	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

void fragment() {
	vec2 noisecoord1 = UV;
	vec2 noisecoord2 = UV;
	vec2 motion1 = vec2(TIME * 0.3, TIME * -0.4);
	vec2 motion2 = vec2(TIME * 0.1, TIME * 0.5);
	vec2 distort1 = vec2(noise(noisecoord1 + motion1), noise(noisecoord2 + motion1)) - vec2(0.5);
	vec2 distort2 = vec2(noise(noisecoord1 + motion2), noise(noisecoord2 + motion2)) - vec2(0.5);
	vec2 distort_sum = (distort1 + distort2) / 60.0;
	
	vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV + distort_sum, 0.0);
	vec4 tex_color = textureLod(TEXTURE, UV, 0.0);
	vec4 green_color = vec4(0.0, 1.0, 0.0, 1.0);
	vec2 ps = vec2(1.0, 1.0);// TEXTURE_PIXEL_SIZE;
	float radius=0.02;
    vec2 pos = SCREEN_UV;

	// Add blur
	vec4 sec_color = vec4(0.0);
	color += textureLod(SCREEN_TEXTURE, pos + vec2(0, -radius)*ps, 0.0);
	color += textureLod(SCREEN_TEXTURE, pos + vec2(0, radius)*ps, 0.0);
	color += textureLod(SCREEN_TEXTURE, pos + vec2(-radius, 0)*ps, 0.0);
	color += textureLod(SCREEN_TEXTURE, pos + vec2(radius, 0)*ps, 0.0);
	
	color /= 5.0;
	float thresh = step(0.3, tex_color.a);
	float alpha_old = color.a;
	color = mix(color, green_color, 0.3);
	color.a = alpha_old;

	vec4 result_color = vec4(thresh * 0.7, thresh * 0.9, thresh, thresh);
	result_color = vec4(color.r, color.g, color.b, thresh);
	
	COLOR = result_color;
}