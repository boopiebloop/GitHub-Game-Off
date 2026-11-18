# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name CharacterWalkingState
extends CharacterState


@export var _movement_speed:float = 100
var _animated_sprite:AnimatedSprite2D


func _ready() -> void:
	await super()
	if character:
		_animated_sprite = character.get_animated_sprite()
	if not _animated_sprite:
		printerr("Missing required dependency 'character._animated_sprite'! Disabling...")
		process_mode = Node.PROCESS_MODE_DISABLED


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
	character.velocity.x = direction * _movement_speed


func _update_sprite_direction() -> void:
	if character.velocity.x < 0 and not _animated_sprite.flip_h:
		_animated_sprite.flip_h = true
	elif character.velocity.x > 0 and _animated_sprite.flip_h:
		_animated_sprite.flip_h = false
