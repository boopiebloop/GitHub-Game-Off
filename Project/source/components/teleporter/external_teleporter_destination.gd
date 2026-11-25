# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name ExternalTeleporterDestination
extends TeleporterDestination


@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY)
var _external_link_paths:Dictionary[NodePath, Array] = {}


func _ready() -> void:
	_external_link_paths.clear()
	super()

func add_link(linking_teleporter:Teleporter) -> void:
	super(linking_teleporter)
	if not linking_teleporter.owner is RuinsArea:
		return
	var linking_teleporter_path := linking_teleporter.get_path()
	var ruins_area:RuinsArea = linking_teleporter.owner
	var linked_teleporter_paths:Array[NodePath] = []
	linked_teleporter_paths = _external_link_paths.get_or_add(ruins_area.get_path(), linked_teleporter_paths)
	if not linked_teleporter_paths.has(linking_teleporter_path):
		linked_teleporter_paths.append(linking_teleporter_path)

func remove_link(removing_teleporter:Teleporter) -> void:
	super(removing_teleporter)
	if not removing_teleporter:
		push_error("Null value!")
		return
	elif not removing_teleporter.owner is RuinsArea:
		return
	var ruins_area:RuinsArea = removing_teleporter.owner
	var ruins_area_path:NodePath = ruins_area.get_path()
	if _synced_teleporter and ruins_area == _synced_teleporter.owner:
		return
	elif not _external_link_paths.has(ruins_area_path):
		return
	var linked_teleporter_paths:Array[NodePath] = _external_link_paths[ruins_area_path]
	linked_teleporter_paths.erase(removing_teleporter.get_path())
	if linked_teleporter_paths.is_empty():
		_external_link_paths.erase(ruins_area_path)
