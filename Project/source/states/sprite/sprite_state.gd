# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
@abstract
class_name SpriteState
extends State




# --- Signals --- #
																									
# ----------------------------------------------------------------------------------------------- #


# ...




# --- Properties --- #
																									
# ----------------------------------------------------------------------------------------------- #


# References:

@export var animated_sprite:AnimatedSprite2D


# Variables:

@export var _entered_animation_name:String = _get_default_animation_name()




# --- Methods --- #
																									
# ----------------------------------------------------------------------------------------------- #


func _get_default_animation_name() -> String:
	return ""


func _play_animation(animation_name:String) -> void:
	if animation_name.is_empty(): # Invalid animation since it's empty.
		return
	animated_sprite.play(animation_name)
	if animated_sprite.is_playing():
		await _wait_for_animation_completion()


func _wait_for_animation_completion() -> void:
	if not animated_sprite.is_playing():
		return
	var is_looping:bool = animated_sprite.sprite_frames.get_animation_loop(animated_sprite.animation)
	if is_looping:
		await animated_sprite.animation_looped
	else:
		await animated_sprite.animation_finished


func _process(delta:float) -> void:
	if Engine.is_editor_hint() or not has_required_dependencies():
		return
	else:
		_state_process(delta)


@warning_ignore("unused_parameter")
func _state_process(delta:float) -> void:
	pass


func _start_running() -> void:
	_play_animation(_entered_animation_name)


func _get_required_dependency_properties() -> Array[String]:
	return ["animated_sprite"]
