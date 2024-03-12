shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform vec2 offset = vec2(2, 2);

void fragment() {
	COLOR = textureLod(screen_texture, SCREEN_UV + vec2(0.02, 0.02), 0.0);
}