extends Node

@export var colors: ColorPaletteResource

func set_color_palette_replace(material: ShaderMaterial):
	material.set_shader_parameter("new_color_dark", colors.dark)
	material.set_shader_parameter("new_color_light", colors.light)
	material.set_shader_parameter("new_color_accent", colors.accent)
