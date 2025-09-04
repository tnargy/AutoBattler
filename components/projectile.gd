@tool
class_name Projectile
extends Node2D

@export var speed: int

var hitbox: HitBox:
	set(value):
		hitbox = value
		update_configuration_warnings()
var visibility_notifier: VisibleOnScreenNotifier2D:
	set(value):
		visibility_notifier = value
		update_configuration_warnings()
var target: Vector2:
	set(value):
		target = value
		direction = global_position.direction_to(target)
var direction: Vector2


func _enter_tree():
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)


func _physics_process(delta):
	if not target:
		return
		
	global_position += direction * speed * delta


func _get_configuration_warnings() -> PackedStringArray:
	if not hitbox or not visibility_notifier:
		return ["Projectles need to have HitBox and VisibleOnScreenNotifier2D children nodes!"]
	else:
		return []


func _on_child_entered_tree(child: Node):
	if not hitbox and child is HitBox:
		hitbox = child as HitBox
		hitbox.hit.connect(queue_free)
	
	if not visibility_notifier and child is VisibleOnScreenNotifier2D:
		visibility_notifier = child as VisibleOnScreenNotifier2D
		visibility_notifier.screen_exited.connect(queue_free)
	
func _on_child_exiting_tree(child: Node):
	if not Engine.is_editor_hint():
		return
	
	if child == hitbox:
		hitbox.hit.disconnect(queue_free)
		hitbox = null
	
	if child == visibility_notifier:
		visibility_notifier.screen_exited.disconnect(queue_free)
		visibility_notifier = null
