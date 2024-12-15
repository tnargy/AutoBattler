class_name  RerollButton
extends Button

@export var player_stats: PlayerStats
@onready var hbox_container = $HBoxContainer


func _ready():
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()


func _on_player_stats_changed():
	var has_enough_gold := player_stats.gold >= 2
	disabled = not has_enough_gold

	if has_enough_gold:
		hbox_container.modulate.a = 1.0
	else:
		hbox_container.modulate.a = 0.5


func _on_pressed():
	player_stats.gold -= 2
