# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name Switchable
extends Node


@export var _max_states:int = 2:
	set(value):
		_max_states = min(2, value)
		_current_state_index = _current_state_index
@export var _current_state_index:int = 0:
	set(value):
		_current_state_index = clampi(value, 0, _max_states - 1)
@export var _connected_animation_tree:AnimationTree

@warning_ignore("unused_private_class_variable")
@export_tool_button("Switch") var _switch_callable:Callable = switch

func _ready() -> void:
	_update_animation_tree_parameters()

func switch() -> void:
	_current_state_index = (_current_state_index + 1) % _max_states
	_update_animation_tree_parameters()

func get_current_state_index() -> int:
	return _current_state_index

func _update_animation_tree_parameters() -> void:
	if not _connected_animation_tree:
		return
	for state in range(_max_states):
		var parameter := "parameters/conditions/switch_state_index_%s" % state
		if _current_state_index == state:
			_connected_animation_tree.set(parameter, true)
		else:
			_connected_animation_tree.set(parameter, false)
