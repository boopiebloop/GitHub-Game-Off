# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name CharacterBodyActivator
extends Node


@export var _character_body:CharacterBody2D


func _ready() -> void:
	if not _character_body:
		var parent := get_parent()
		if parent is CharacterBody2D:
			_character_body = parent

func _physics_process(_delta:float) -> void:
	if not _character_body:
		return
	else:
		_character_body.move_and_slide()

func _get_configuration_warnings() -> PackedStringArray:
	if not _character_body:
		return ["No '_character_body' set!"]
	else:
		return []
