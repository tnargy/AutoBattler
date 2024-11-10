class_name UnitGrid
extends Node2D

signal unit_grid_changed

@export var size: Vector2i

var units: Dictionary


func  _ready():
	for i in size.x:
		for j in size.y:
			units[Vector2i(i,j)] = null


    # TESTS
	# add_unit(Vector2i(0,0), $"../../Bench/Unit")
	# print("(0,0) tile_occupied: ", is_tile_occupied(Vector2i(0,0)))
	# print("is_grid_full(): ", is_grid_full())
	# print("first_empty_tile: ", get_first_empty_tile())
	# print("array of all units: ", get_all_units())


func add_unit(tile: Vector2i, unit: Node):
	units[tile] = unit
	unit_grid_changed.emit()


func is_tile_occupied(tile: Vector2i) -> bool:
	return units[tile] != null


func is_grid_full() -> bool:
	return units.keys().all(is_tile_occupied)


func get_first_empty_tile() -> Vector2i:
	for tile in units:
		if not is_tile_occupied(tile):
			return tile

	# no empty tile
	return Vector2i(-1, -1)


func get_all_units() -> Array[Unit]:
	var unit_array: Array[Unit] = []

	for unit: Unit in units.values():
		if unit:
			unit_array.append(unit)

	return unit_array
