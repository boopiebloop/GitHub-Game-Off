# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name Activatable
extends Node


signal activated
signal deactivated

@export var _activated:bool = false:
	set = _set_activated

@export var _connected_animation_tree:AnimationTree


func _ready() -> void:
	if _activated:
		activate()
	else:
		deactivate()

func _set_activated(value:bool) -> void:
	var toggled:bool = not _activated == value
	_activated = value
	if toggled:
		_update_activation()

func _update_activation() -> void:
	if _activated:
		activate()
	else:
		deactivate()

func activate() -> void:
	if not _activated:
		_activated = true
		return
	activated.emit()
	if _connected_animation_tree:
		_connected_animation_tree.set("parameters/conditions/activated", true)
		_connected_animation_tree.set("parameters/conditions/deactivated", false)

func deactivate() -> void:
	if _activated:
		_activated = false
		return
	deactivated.emit()
	if _connected_animation_tree:
		_connected_animation_tree.set("parameters/conditions/activated", false)
		_connected_animation_tree.set("parameters/conditions/deactivated", true)

func toggle_activation() -> void:
	_activated = not _activated
