shader_type canvas_item;

uniform vec4 old_color : source_color;
uniform vec4 new_color : source_color;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (color == old_color) COLOR = new_color;
	else COLOR = color;
}
