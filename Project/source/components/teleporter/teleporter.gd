# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name Teleporter
extends Node2D


@export var destination:TeleporterDestination:
	set(value):
		if destination == value:
			return
		if destination and not destination == value:
			if not is_node_ready():
				await ready
			destination.remove_link(self)
		destination = value
		if destination:
			if not is_node_ready():
				await ready
			destination.add_link(self)


func teleport(body:Node2D) -> void:
	if not destination:
		push_error("Invalid 'destination' set! Cannot teleport.")
	else:
		body.global_position = destination.global_position

func _get_configuration_warnings() -> PackedStringArray:
	if owner and not destination:
		return ["No valid 'destination' set! You can ignore this if you're setting this later via a RuinsArea."]
	else:
		return []

func get_destination_path() -> NodePath:
	if not destination:
		return ""
	else:
		if not destination.is_node_ready():
			await destination.ready
		return destination.get_path()

func is_internally_linked() -> bool:
	if destination:
		if not destination.is_node_ready():
			await destination.ready
		return destination.owner == owner
	else:
		return false
