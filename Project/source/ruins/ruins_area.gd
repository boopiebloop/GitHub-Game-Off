# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name RuinsArea
extends Node2D


var _teleporters:Array[Teleporter] = []
@export var _teleporter_linker := TeleporterLinker.new():
	set(value):
		_teleporter_linker = value
		if _teleporter_linker:
			_teleporter_linker.resource_local_to_scene = true
			if not _teleporter_linker.links_changed.is_connected(_on_teleporter_linker_links_changed):
				_teleporter_linker.links_changed.connect(_on_teleporter_linker_links_changed)
			_update_teleporter_linker()
var _waiting_to_update_teleporter_linker:bool = false


func _init() -> void:
	if not child_entered_tree.is_connected(_on_child_entered_tree):
		child_entered_tree.connect(_on_child_entered_tree)
	if not child_exiting_tree.is_connected(_on_child_exited_tree):
		child_exiting_tree.connect(_on_child_exited_tree)

func _ready() -> void:
	_update_teleporter_linker()

func _get_configuration_warnings() -> PackedStringArray:
	if not owner or not has_unlinked_teleporters():
		return []
	var warnings:Array[String] = ["Contains teleporters with no destinations!"]
	if not _teleporter_linker:
		warnings.append("You can set '_teleporter_linker' to link their destinations.")
	else:
		warnings.append("Make sure to link the destinations using '_teleporter_linker'!")
	return warnings

func has_unlinked_teleporters() -> bool:
	for teleporter in _teleporters:
		if not teleporter.destination:
			return true
	return false

func _update_teleporter_linker() -> void:
	if not _teleporter_linker or _waiting_to_update_teleporter_linker:
		return
	_waiting_to_update_teleporter_linker = true
	if not is_node_ready():
		await ready
	if owner and not owner.is_node_ready():
		await owner.ready
	_teleporter_linker.update(_teleporters, self)
	_waiting_to_update_teleporter_linker = false

func _on_teleporter_linker_links_changed() -> void:
	_update_teleporter_linker()
	update_configuration_warnings()

func _on_child_entered_tree(child:Node) -> void:
	if not child is Teleporter:
		return
	elif _teleporters.has(child):
		return
	else:
		var teleporter:Teleporter = child
		_teleporters.append(teleporter)
	_update_teleporter_linker()

func _on_child_exited_tree(child:Node) -> void:
	if not child is Teleporter:
		return
	elif not _teleporters.has(child):
		return
	else:
		var teleporter:Teleporter = child
		_teleporters.erase(teleporter)
	_update_teleporter_linker()
