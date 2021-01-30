shader_type canvas_item;

uniform float stripe_count: hint_range(0.0, 1000.0);
uniform float offset: hint_range(-1.0, 1.0);


float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


void fragment() {
	float PI = 3.14159;
	vec2 uv = UV * stripe_count;
	vec2 ipos = floor(uv);
	vec2 fpos = fract(uv);
	
	float i = ipos.y, f = fpos.y;
	float real_offset = rand(vec2(i)) * offset;
	
	COLOR = texture(TEXTURE, UV + mod(i, 2.0) * vec2(real_offset, 0));
}
