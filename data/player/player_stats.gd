class_name PlayerStats
extends Resource

const XP_REQUIREMENTS := {
	1: 0,
	2: 2,
	3: 2,
	4: 6,
	5: 10,
	6: 20,
	7: 36,
	8: 48,
	9: 76,
	10: 76
}

@export_range(0, 99) var gold: int:
	set(value):
		gold = value
		emit_changed()
@export_range(0, 99) var xp: int : set = _set_xp
@export_range(1, 10) var level: int:
	set(value):
		level = value
		emit_changed()
	

func _set_xp(value: int):
	xp = value
	emit_changed()

	if level == 10:
		return

	var xp_requirement: int = get_current_xp_requirements()

	while level< 10 and xp >= xp_requirement:
		level += 1
		xp -= xp_requirement
		xp_requirement = get_current_xp_requirements()
		emit_changed()


func get_current_xp_requirements() -> int:
	var next_level = clamp(level+1, 1, 10)
	return XP_REQUIREMENTS[next_level]
