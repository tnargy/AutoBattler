class_name UnitAI
extends Node

@export var enabled: bool:
	set(value):
		enabled = value
		
		if enabled:
			_start_chasing()
			actor.stats.mana_bar_filled.connect(_on_mana_bar_filled)
		else:
			fsm.change_state(null)
			actor.stats.mana_bar_filled.disconnect(_on_mana_bar_filled)
@export var actor: BattleUnit
@export var fsm_debug_label = Label


var fsm: FiniteStateMachine


func _ready():
	fsm = FiniteStateMachine.new()
	fsm.state_changed.connect(
		func(new_state: State):
			if not fsm_debug_label:
				return
			fsm_debug_label.text = new_state.get_script().get_global_name()
	)


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
	aa_state.target_died.connect(_start_chasing, CONNECT_ONE_SHOT)
	aa_state.target_left_range.connect(_start_chasing, CONNECT_ONE_SHOT)
	fsm.change_state(aa_state)


func _on_mana_bar_filled():
	var cast_state := CastState.new(actor)
	cast_state.ability_cast_finished.connect(_start_chasing, CONNECT_ONE_SHOT)
	fsm.change_state(cast_state)
