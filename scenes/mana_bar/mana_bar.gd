class_name ManaBar
extends ProgressBar

@export var stats: UnitStats:
	set(value):
		stats = value
		stats.changed.connect(_on_stats_changed)
		_on_stats_changed()
		

func _on_stats_changed():
	value = stats.mana / float(stats.max_mana) * 100
