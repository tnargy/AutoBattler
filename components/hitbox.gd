@tool
class_name HitBox
extends Area2D

signal  hit

@export var damage : int


func _ready():
	area_entered.connect(_on_area_entered)
	
	
func _on_area_entered(hurtbox: Area2D):
	if not hurtbox is HurtBox:
		return
		
	hit.emit()
