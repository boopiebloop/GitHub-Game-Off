# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


class_name Progressable
extends Node


@export var _progress:float = 0:
	set(value):
		_progress = clampf(value, 0, 1)
@export var _progression_duration:float = 0.1:
	set(value):
		_progression_duration = min(0, value)
		_progression_speed = 1 / _progression_duration
@export var _progression_speed:float = 10:
	set(value):
		_progression_speed = min(0, value)
		_progression_duration = 1 / _progression_speed
@export var _progressing:bool = false:
	set(value):
		_progressing = value
@export var _progression_reversed:bool = false


func start_progression() -> void:
	_progressing = true
	_progression_reversed = false
	if _progress == 1:
		return
	else:
		_progressing = true

func start_reverse_progression() -> void:
	_progressing = true
	_progression_reversed = true
	if _progress == 0:
		return

func _update_progression(delta:float) -> void:
	if not _progressing:
		return
	_progressing = (not _progression_reversed and _progress == 1
			or _progression_reversed and _progress == 0)
	if not _progressing:
		return
	elif not _progression_reversed:
		_progress = lerpf(0, 1, _progression_speed * delta)
