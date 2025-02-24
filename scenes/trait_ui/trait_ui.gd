class_name TraitUI
extends PanelContainer

@export var trait_data: Trait : 
	set(value):
		if not is_node_ready():
			await ready
			
		trait_data = value
		trait_icon.texture = trait_data.icon
		trait_label.text = trait_data.name
@export var active: bool :
	set(value):
		active = value
		if active:
			modulate.a = 1.0
		else:
			modulate.a = 0.5

@onready var trait_icon : TextureRect = %TraitIcon
@onready var active_unit_label : Label = %ActiveUnitLabel
@onready var trait_level_labels : RichTextLabel = %TraitLevelLabels
@onready var trait_label : Label = %TraitLabel


func update(units: Array[Unit]):
	var unique_units := trait_data.get_unique_unit_cont(units)
	active_unit_label.text = str(unique_units)
	trait_level_labels.text = trait_data.get_levels_bbcode(unique_units)
	active = trait_data.is_active(unique_units)
