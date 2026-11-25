# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name SpriteIdleState
extends SpriteState


func _get_default_animation_name() -> String:
	return "idle"

func can_run() -> bool:
	return true
