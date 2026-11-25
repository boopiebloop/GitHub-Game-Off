# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name CharacterStateMachine
extends SpriteStateMachine


@export var _character_body:CharacterBody2D


func _get_required_dependency_properties() -> Array[String]:
	return DSM.append_and_return(super(), "_character_body")


func _set_state_dependencies(state:State) -> void:
	super(state)
	if not state is CharacterState:
		return
	else:
		var character_state:CharacterState = state
		character_state.character_body = _character_body
		character_state.update_configuration_warnings()
