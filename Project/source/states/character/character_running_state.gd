# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name CharacterRunningState
extends CharacterWalkingState


@export var _walking_state:CharacterWalkingState


func _get_default_animation_name() -> String:
	return "running"


func can_run() -> bool:
	if super() and Input.is_action_pressed("run"):
		return true
	else:
		return false


func _state_physics_process(delta:float) -> void:
	if can_run():
		if _walking_state.process_mode == ProcessMode.PROCESS_MODE_INHERIT:
			_walking_state.process_mode = ProcessMode.PROCESS_MODE_DISABLED
		super(delta)
	elif _walking_state.process_mode == ProcessMode.PROCESS_MODE_DISABLED:
		_walking_state.process_mode = ProcessMode.PROCESS_MODE_INHERIT
