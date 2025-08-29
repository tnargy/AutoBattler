class_name UnitAI
extends Node

@export var enabled: bool:
	set(value):
		enabled = value
		
		if enabled:
			_start_chasing()
		else:
			fsm.change_state(null)
@export var actor: BattleUnit
@export var fsm: FiniteStateMachine


func _physics_process(delta):
	if not enabled:
		return
	
	fsm.state.physics_process(delta)


func _process(delta):
	if not enabled:
		return
	
	fsm.state.process(delta)


func _start_chasing():
	var chase_state := ChaseState.new(actor)
	chase_state.stuck.connect(_on_chase_state_stuck, CONNECT_ONE_SHOT)
	chase_state.target_reached.connect(_on_chase_state_target_reached, CONNECT_ONE_SHOT)
	fsm.change_state(chase_state)
	
	chase_state.chase()


func _on_chase_state_stuck():
	var stuck_state := StuckState.new(actor)
	stuck_state.timeout.connect(_start_chasing, CONNECT_ONE_SHOT)
	fsm.change_state(stuck_state)
	
	
func _on_chase_state_target_reached(target: BattleUnit):
	var aa_state := AutoAttackState.new(actor, target)
	fsm.change_state(aa_state)
