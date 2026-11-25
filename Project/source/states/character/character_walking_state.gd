# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name CharacterWalkingState
extends CharacterState


@export var _movement_speed:float = 100


func _get_default_animation_name() -> String:
	return "walking"


func can_run() -> bool:
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		return true
	else:
		return false


func _state_physics_process(_delta:float) -> void:
	_update_velocity_for_movement()
	_update_sprite_direction()


func _update_velocity_for_movement() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	character_body.velocity.x = direction * _movement_speed


func _update_sprite_direction() -> void:
	if character_body.velocity.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	elif character_body.velocity.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
