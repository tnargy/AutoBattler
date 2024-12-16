class_name XPTracker
extends VBoxContainer

@export var player_stats: PlayerStats

@onready var progress_bar = %ProgressBar
@onready var xp_label = %XPLabel
@onready var level_label = %LevelLabel


func _ready():
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()


func _on_player_stats_changed():
	if player_stats.level < 10:
		_set_xp_bar_values()
	else:
		_set_max_level_values()

	level_label.text = "lvl: %s" % player_stats.level


func _set_xp_bar_values():
	var xp_requirement: float = player_stats.get_current_xp_requirements()
	xp_label.text = "%s/%s" % [player_stats.xp, xp_requirement]
	progress_bar.value = (player_stats.xp / xp_requirement) * 100


func _set_max_level_values():
	xp_label.text = "MAX"
	progress_bar.value = 100
