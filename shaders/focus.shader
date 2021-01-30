shader_type canvas_item;

uniform float black_width: hint_range(0.0, 0.5) = 0.0;

float plot(float edge0, float edge1, float x) {
	return step(edge0, x) - step(edge1, x);
}

void fragment() {
	float opacity = 1.0 - plot(black_width, 1.0 - black_width, UV.y);
    COLOR = vec4(vec3(0.0), opacity);
}
