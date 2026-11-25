# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name SpriteStateMachine
extends StateMachine


@export var _animated_sprite:AnimatedSprite2D


func _get_required_dependency_properties() -> Array[String]:
	return ["_animated_sprite"]


func _set_state_dependencies(state:State) -> void:
	if not state is SpriteState:
		return
	else:
		var sprite_state:SpriteState = state
		sprite_state.animated_sprite = _animated_sprite
		sprite_state.update_configuration_warnings()
