# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name GameCharacter
extends CharacterBody2D


@export var _animated_sprite:AnimatedSprite2D
func get_animated_sprite() -> AnimatedSprite2D:
	return _animated_sprite


func _physics_process(_delta: float) -> void:
	move_and_slide()


func play_animation(animation_name:String) -> void:
	if animation_name.is_empty(): # Invalid animation since it's empty.
		return
	_animated_sprite.play(animation_name)
	if _animated_sprite.is_playing():
		await wait_for_animation_completion()


func wait_for_animation_completion() -> void:
	if not _animated_sprite.is_playing():
		return
	var is_looping:bool = _animated_sprite.sprite_frames.get_animation_loop(_animated_sprite.animation)
	if is_looping:
		await _animated_sprite.animation_looped
	else:
		await _animated_sprite.animation_finished


func _get_configuration_warnings() -> PackedStringArray:
	if not _animated_sprite:
		return ["Required dependency '_sprite' is missing!"]
	else:
		return []
