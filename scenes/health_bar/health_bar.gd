class_name HealthBar
extends ProgressBar

@export var stats: UnitStats:
	set(value):
		stats = value
		stats.changed.connect(_on_stats_changed)
		_on_stats_changed()
		

func _on_stats_changed():
	value = stats.health / float(stats.get_max_health()) * 100
