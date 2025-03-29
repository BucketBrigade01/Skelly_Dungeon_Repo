shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;

const float curvature = 7.0;
const vec2 GAME_RESOLUTION = vec2(8192.0, 7168.0);

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float ca_strength = 1.0;

void fragment() {
	vec3 scan_lines = vec3(sin(2.0 * SCREEN_UV.y * 896.0) * 0.25 + 0.9);
	vec2 ca_offset = vec2(ca_strength / GAME_RESOLUTION.x, 0.0);;

	float red = texture(screen_texture, SCREEN_UV - ca_offset).r;
	float green = texture(screen_texture, SCREEN_UV).g;
	float blue = texture(screen_texture, SCREEN_UV + ca_offset).b;

	vec3 final_color = vec3(red, green, blue) * scan_lines;
	COLOR = vec4(final_color, 1.0);
}
