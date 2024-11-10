class_name OutlineHighlighter
extends Node

@export var visuals: CanvasGroup
@export var outline_color: Color
@export_range(1, 10) var outline_thickness: int

func _ready():
	visuals.material.set_shader_parameter("line_color", outline_color)


func clear_highlight():
	visuals.material.set_shader_parameter("line_thickness", 0)


func highlight():
	visuals.material.set_shader_parameter("line_thickness", outline_thickness)
