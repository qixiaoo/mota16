shader_type canvas_item;

uniform float brightness: hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
    c.rgb = mix(c.rgb, vec3(0.0), brightness);
    COLOR.rgb = c;
}
