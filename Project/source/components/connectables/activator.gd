# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name Activator
extends Activatable


@export var _activated_linked_activatables:bool = false:
	set(value):
		var toggled:bool = not _activated_linked_activatables == value
		_activated_linked_activatables = value
		if not _separate_linked_activation and not _activated == _activated_linked_activatables:
			_activated = _activated_linked_activatables
		if toggled:
			_update_linked_activatables_activation()
@export var _linked_activatables:Array[Activatable] = []
@export var _separate_linked_activation:bool = false:
	set(value):
		_separate_linked_activation = value
		if _separate_linked_activation:
			if activated.is_connected(activate_linked_activatables):
				activated.disconnect(activate_linked_activatables)
			if deactivated.is_connected(deactivate_linked_activatables):
				deactivated.disconnect(deactivate_linked_activatables)
		else:
			if not activated.is_connected(activate_linked_activatables):
				activated.connect(activate_linked_activatables)
			if not deactivated.is_connected(deactivate_linked_activatables):
				deactivated.connect(deactivate_linked_activatables)


func _set_activated(value:bool) -> void:
	var toggled:bool = not _activated == value
	_activated = value
	if not _separate_linked_activation and not _activated == _activated_linked_activatables:
		_activated_linked_activatables = _activated
	if toggled:
		_update_activation()

func activate_linked_activatables() -> void:
	if not _activated_linked_activatables:
		_activated_linked_activatables = true
		return
	for activatable in _linked_activatables:
		activatable.activate()

func deactivate_linked_activatables() -> void:
	if _activated_linked_activatables:
		_activated_linked_activatables = false
		return
	for activatable in _linked_activatables:
		activatable.deactivate()

func toggle_linked_activatables_activation() -> void:
	_activated_linked_activatables = not _activated_linked_activatables

func _update_linked_activatables_activation() -> void:
	if _activated_linked_activatables:
		activate_linked_activatables()
	else:
		deactivate_linked_activatables()
