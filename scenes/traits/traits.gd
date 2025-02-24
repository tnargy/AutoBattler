class_name Traits
extends Control

const TRAIT_UI = preload("res://scenes/trait_ui/trait_ui.tscn")

@export var arena_grid: UnitGrid

@onready var trait_container = %TraitContainer

var current_traits := {}
var traits_to_update: Array
var active_traits: Array[Trait]


func _ready():
	arena_grid.unit_grid_changed.connect(_update_traits)
	
	for trait_ui: TraitUI in trait_container.get_children():
		trait_ui.queue_free()


func _update_traits():
	traits_to_update = current_traits.keys()
	active_traits = []
	var units := arena_grid.get_all_units()
	var traits := Trait.get_unique_traits_for_units(units)
	
	for trait_data: Trait in traits:
		if current_traits.has(trait_data):
			_update_trait_ui(trait_data, units)
		else:
			_create_trait_ui(trait_data, units)
			
	_move_active_traits_to_top()
	_delete_orphan_traits()


func _update_trait_ui(trait_data: Trait, units: Array[Unit]):
	var trait_ui := current_traits[trait_data] as TraitUI
	trait_ui.update(units)
	traits_to_update.erase(trait_data)
	
	if trait_ui.active:
		active_traits.append(trait_data)


func _create_trait_ui(trait_data: Trait, units: Array[Unit]):
	var trait_ui := TRAIT_UI.instantiate() as TraitUI
	trait_container.add_child(trait_ui)
	trait_ui.trait_data = trait_data
	trait_ui.update(units)
	current_traits[trait_data] = trait_ui
	
	if trait_ui.active:
		active_traits.append(trait_data)


func _move_active_traits_to_top():
	for i in active_traits.size():
		var trait_ui := current_traits[active_traits[i]] as TraitUI
		trait_container.move_child(trait_ui, i)


func _delete_orphan_traits():
	for orphan_trait: Trait in traits_to_update:
		var trait_ui := current_traits[orphan_trait] as TraitUI
		current_traits.erase(orphan_trait)
		trait_ui.queue_free()
