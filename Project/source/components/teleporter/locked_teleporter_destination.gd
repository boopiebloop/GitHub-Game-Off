# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name LockedTeleporterDestination
extends ExternalTeleporterDestination


func _init(new_synchronised_teleporter:Teleporter = null) -> void:
	_synced_teleporter = new_synchronised_teleporter

func _set_synchronised_teleporter(teleporter:Teleporter) -> void:
	if _synced_teleporter:
		push_error("Cannot change the synchronised teleporter since its locked!")
		return
	else:
		super(teleporter)
