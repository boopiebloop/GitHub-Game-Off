# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name CharacterFallingState
extends CharacterState


func _get_default_animation_name() -> String:
	return "fall"

func can_run() -> bool:
	if character_body.is_on_floor():
		return false
	elif character_body.velocity.y <= 0:
		return false
	else:
		return true
