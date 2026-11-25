# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name TeleporterLink
extends Resource


signal destination_updated

var _teleporter:Teleporter
var _teleporter_path:NodePath
@export_node_path("TeleporterDestination") var destination_path:NodePath:
	set(value):
		destination_path = value
		destination_updated.emit()
