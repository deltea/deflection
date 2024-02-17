shader_type canvas_item;

uniform vec4 old_color_dark : source_color = vec4(0, 0, 0, 1);
uniform vec4 old_color_light : source_color = vec4(1, 1, 1, 1);
uniform vec4 old_color_accent : source_color = vec4(1, 0, 0, 1);

uniform vec4 new_color_dark : source_color = vec4(0, 0, 0, 1);
uniform vec4 new_color_light : source_color = vec4(1, 1, 1, 1);
uniform vec4 new_color_accent : source_color = vec4(1, 0, 0, 1);

void fragment() {
	vec4 color = texture(TEXTURE, UV);

	if (color == old_color_dark) COLOR = new_color_dark;
	else if (color == old_color_light) COLOR = new_color_light;
	else if (color == old_color_accent) COLOR = new_color_accent;
	else COLOR = color;
}
