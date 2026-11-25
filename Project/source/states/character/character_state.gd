# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
@abstract
class_name CharacterState
extends SpriteState


@export var character_body:CharacterBody2D

# Calls [method _state_physics_process] when relevant. 
func _physics_process(delta:float) -> void:
	if Engine.is_editor_hint() or not has_required_dependencies():
		return
	else:
		_state_physics_process(delta)


func _get_required_dependency_properties() -> Array[String]:
	return ["character_body"]


func _get_default_animation_name() -> String:
	return ""


## Called from [method _physics_process], only when not in the editor and when dependencies are
## satisfied. Essentially safe for implementing any state logic.
@warning_ignore("unused_parameter")
func _state_physics_process(delta:float) -> void:
	pass
