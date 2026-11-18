# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name CharacterStateMachine
extends StateMachine


@export_group("Required Dependencies")
@export var _character:GameCharacter


func _get_required_dependency_properties() -> Array[String]:
	return ["_character"]


func _set_state_dependencies(state:State) -> void:
	if not state is CharacterState:
		return
	else:
		var character_state:CharacterState = state
		character_state.character = _character
		character_state.update_configuration_warnings()
