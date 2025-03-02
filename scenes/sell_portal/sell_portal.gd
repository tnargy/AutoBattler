class_name SellPortal
extends Area2D

@export var unit_pool: UnitPool
@export var player_stats: PlayerStats
@export var sell_sound: AudioStream

@onready var outline_highlighter = $OutlineHighlighter
@onready var gold = %Gold
@onready var gold_label = %GoldLabel

var current_unit: Unit


func _ready():
	var units := get_tree().get_nodes_in_group("units")
	for unit: Unit in units:
		setup_unit(unit)
		
		
func setup_unit(unit: Unit):
	unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit))
	unit.quick_sell_pressed.connect(_sell_unit.bind(unit))


func _on_area_entered(unit: Unit):
	current_unit = unit
	outline_highlighter.highlight()
	gold_label.text = str(unit.stats.get_gold_value())
	gold.show()


func _on_area_exited(unit: Unit):
	if unit and current_unit == unit:
		current_unit = null
	outline_highlighter.clear_highlight()
	gold.hide()

	
func _sell_unit(unit: Unit):
	player_stats.gold += unit.stats.get_gold_value()
	# Todo: give items back to item pool
	unit_pool.add_unit(unit.stats)
	unit.queue_free()
	SFXPlayer.play(sell_sound)

	
func _on_unit_dropped(_starting_position: Vector2, unit: Unit):
	if unit and unit == current_unit:
		_sell_unit(unit)
	
