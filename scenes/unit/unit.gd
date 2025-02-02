@tool
class_name Unit
extends Area2D

signal quick_sell_pressed

@export var stats: UnitStats : set = set_stats

@onready var skin: Sprite2D = $Visuals/Skin
@onready var health_bar: ProgressBar = $HealthBar
@onready var mana_bar: ProgressBar = $ManaBar
@onready var tier_icon = $TierIcon
@onready var drag_and_drop = $DragAndDrop
@onready var velocity_based_rotation = $VelocityBasedRotation
@onready var outline_highlighter = $OutlineHighlighter
@onready var animations = $UnitAnimations


var is_hovered := false


func _ready():
	if not Engine.is_editor_hint():
		drag_and_drop.drag_started.connect(_on_drag_started)
		drag_and_drop.drag_canceled.connect(_on_drag_canceled)
		
		
func _input(event):
	if not is_hovered: return
	
	if event.is_action_pressed("quick_sell"):
		quick_sell_pressed.emit()


func set_stats(value: UnitStats):
	stats = value
	
	if value == null:
		return

	if not is_node_ready():
		await ready

	if not Engine.is_editor_hint():
		stats = value.duplicate()
		
	skin.region_rect.position = Vector2(stats.skin_coordinates) * Arena.CELL_SIZE
	tier_icon.stats = stats


func reset_after_dragging(starting_position: Vector2):
	velocity_based_rotation.enabled = false
	global_position = starting_position


func _on_drag_started():
	velocity_based_rotation.enabled = true


func _on_drag_canceled(starting_position: Vector2):
	reset_after_dragging(starting_position)


func _on_mouse_entered():
	if drag_and_drop.dragging:
		return
	
	is_hovered = true
	outline_highlighter.highlight()
	z_index = 1


func _on_mouse_exited():
	if drag_and_drop.dragging:
		return
	
	is_hovered = false
	outline_highlighter.clear_highlight()
	z_index = 0
