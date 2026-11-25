# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name TeleporterDestination
extends Marker2D


signal synchronised_teleporter_set


@export var _synced_teleporter:Teleporter:
	set = _set_synchronised_teleporter
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY)
var _linked_teleporter_paths:Array[NodePath] = []:
	set(value):
		_linked_teleporter_paths = value


func _ready() -> void:
	_linked_teleporter_paths.clear()
	rotation_degrees = 45

func _set_synchronised_teleporter(teleporter:Teleporter) -> void:
	if teleporter and teleporter.destination == self:
		push_error("Can't set corresponding TeleporterDestination can't to a teleporter already linked!")
		return
	_synced_teleporter = teleporter
	synchronised_teleporter_set.emit()
	update_configuration_warnings()

func _process(_delta:float) -> void:
	if _synced_teleporter:
		global_position = _synced_teleporter.global_position

func add_link(linking_teleporter:Teleporter) -> void:
	if not linking_teleporter:
		push_error("Null value!")
		return
	var linking_teleporter_path := linking_teleporter.get_path()
	if _linked_teleporter_paths.has(linking_teleporter_path):
		return
	_linked_teleporter_paths.append(linking_teleporter_path)

func is_teleporter_linked(checking_teleporter:Teleporter) -> bool:
	if not checking_teleporter:
		return false
	elif not checking_teleporter.is_node_ready():
		push_error("Attempted to check if teleporter is linked before it's ready! Returning false...")
		return false
	else:
		return _linked_teleporter_paths.has(checking_teleporter.get_path())

func remove_link(removing_teleporter:Teleporter) -> void:
	if not removing_teleporter:
		push_error("Null value!")
		return
	var path := removing_teleporter.get_path()
	_linked_teleporter_paths.erase(path)

func get_synchronised_teleporter() -> Teleporter:
	return _synced_teleporter
