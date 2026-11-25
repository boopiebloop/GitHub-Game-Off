# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name TeleporterLinker
extends Resource


#signal owner_set
#
#var owner:Node:
	#set(value):
		#owner = value
		#if owner:
			#owner_set.emit()
#var teleporters:Array[Teleporter] = []
#var _external_synced_destinations:Dictionary[Teleporter, LockedTeleporterDestination] = {}
#
#@export var _links:Array[TeleporterLink] = []
#var _teleporter_link_map:Dictionary[Teleporter, TeleporterLink] = {}
#
#@warning_ignore("unused_private_class_variable")
#@export_tool_button("Generate External Destinations") 
#var _generate_external_destinations_callable := _generate_external_destinations
#
#
#func update() -> void:
	#await _wait_for_owner()
	#for teleporter:Teleporter in _teleporter_link_map.duplicate():
		#_remove_link(teleporter)
	#_teleporter_link_map.clear()
	#_links.clear()
	#var checked_teleporters:Array[Teleporter] = []
	#for teleporter:Teleporter in teleporters.duplicate():
		#if not is_instance_valid(teleporter):
			#printerr("Null value within teleporters! Removing...")
			#if _teleporter_link_map.has(teleporter):
				#_remove_link(teleporter)
			#teleporters.erase(teleporter)
		#elif not teleporter.is_node_ready():
			#await teleporter.ready
		#if not _teleporter_link_map.has(teleporter):
			#await _add_link(teleporter)
		#else:
			#await _update_link(teleporter)
		#checked_teleporters.append(teleporter)
	#for teleporter:Teleporter in _teleporter_link_map.keys():
		#if checked_teleporters.has(teleporter):
			#continue
		#else:
			#_update_link(teleporter)
	#for teleporter in _external_synced_destinations:
		#_update_synced_destination(teleporter, _external_synced_destinations[teleporter])
	#owner.update_configuration_warnings()
#
#func _update_link(teleporter:Teleporter) -> void:
	#if not _teleporter_link_map.has(teleporter):
		#push_error("Can't update link for an unadded teleporter!")
	#elif not is_instance_valid(teleporter) or not teleporters.has(teleporter):
		#_remove_link(teleporter)
		#return
	#await _wait_for_owner()
	#var destination_path := _teleporter_link_map[teleporter].destination_path
	#if destination_path.is_empty():
		#teleporter.destination = null
	#else:
		#var node := owner.get_node(destination_path)
		#var destination:TeleporterDestination = node
		#teleporter.destination = destination
		#var link := _teleporter_link_map[teleporter]
		#link.destination_updated.disconnect(_update_link.bind(teleporter))
		#_teleporter_link_map[teleporter].destination_path = await teleporter.get_destination_path()
		#link.destination_updated.connect(_update_link.bind(teleporter))
#
#func _add_link(teleporter:Teleporter) -> void:
	#await _wait_for_owner()
	#if not teleporter:
		#push_error("Can't add link for a null teleporter!")
		#return
	#elif not teleporter.is_node_ready():
		#await teleporter.ready
	#if _teleporter_link_map.has(teleporter):
		#push_warning("Teleporter already added to links!")
	#else:
		#_teleporter_link_map[teleporter] = TeleporterLink.new()
		#_teleporter_link_map[teleporter].resource_local_to_scene = true
		#_teleporter_link_map[teleporter].resource_name = teleporter.name
		#_teleporter_link_map[teleporter].destination_path = await teleporter.get_destination_path()
		#_teleporter_link_map[teleporter].destination_updated.connect(_update_link.bind(teleporter))
		#_links.append(_teleporter_link_map[teleporter])
#
#func _remove_link(teleporter:Teleporter) -> void:
	#var link := _teleporter_link_map[teleporter]
	#link.destination_updated.disconnect(_update_link.bind(teleporter))
	#_teleporter_link_map.erase(teleporter)
	#_links.erase(link)
#
#func _update_synced_destination(teleporter:Teleporter, destination:TeleporterDestination) -> void:
	#if not _external_synced_destinations.has(teleporter):
		#push_error("Can't update unadded synced teleporter?")
	#elif (not destination or not destination.is_inside_tree() or not teleporter
		#or not teleporters.has(teleporter) or await teleporter.is_internally_linked()):
			#_remove_synced_destination(teleporter, destination)
#
#func _generate_external_destinations() -> void:
	#await _wait_for_owner()
	#if not owner.owner:
		#push_error("This can only be used when the owner is a child in another scene!")
		#return
	#update()
	#for teleporter in teleporters:
		#if await teleporter.is_internally_linked():
			#continue
		#elif _external_synced_destinations.has(teleporter):
			#continue
		#_external_synced_destinations[teleporter] = await _generate_locked_destination(teleporter)
#
#func _generate_locked_destination(teleporter:Teleporter) -> LockedTeleporterDestination:
	#await _wait_for_owner()
	#var destination := LockedTeleporterDestination.new(teleporter)
	#owner.add_child(destination)
	#destination.owner = owner.owner
	#destination.name = teleporter.name + "Destination"
	#return destination
#
#func _remove_synced_destination(teleporter:Teleporter, destination:TeleporterDestination) -> void:
	#if not _external_synced_destinations.has(teleporter):
		#push_error("Can't remove synced destination with an unadded teleporter?")
		#return
	#if destination:
		#if not destination.is_inside_tree():
			#destination.queue_free()
		#else:
			#push_warning("Previously synced destination is now invalid due to being deleted/internally linked.")
			#destination.name = "InvalidUnsyncedTeleporterDestination"
		#_external_synced_destinations.erase(teleporter)
#
#func _wait_for_owner() -> void:
	#if not owner:
		#await owner_set


signal links_changed


@export var _teleporter_path_links:Dictionary[NodePath, NodePath] = {}:
	set(value):
		_teleporter_path_links = value
		links_changed.emit()


func update(teleporters:Array[Teleporter], owner:Node) -> void:
	for teleporter_path:NodePath in _teleporter_path_links.keys():
		if _get_teleporter(teleporter_path, owner):
			continue
		else:
			_teleporter_path_links.erase(teleporter_path)
	for teleporter in teleporters:
		await _update_link(teleporter, owner)


func _update_link(teleporter:Teleporter, owner:Node) -> void:
	var teleporter_path := teleporter.get_path()
	if not _teleporter_path_links.has(teleporter_path):
		_teleporter_path_links[teleporter_path] = await teleporter.get_destination_path()
	var destination := _get_destination(_teleporter_path_links[teleporter_path], owner)
	teleporter.destination = destination
	_teleporter_path_links[teleporter_path] = await teleporter.get_destination_path()

func _get_node(path:NodePath, owner:Node) -> Node:
	if not owner.has_node(path):
		return null
	else:
		return owner.get_node(path)

func _get_teleporter(path:NodePath, owner:Node) -> Teleporter:
	var node := _get_node(path, owner)
	if not node is Teleporter:
		return null
	else:
		var teleporter:Teleporter = node
		return teleporter

func _get_destination(path:NodePath, owner:Node) -> TeleporterDestination:
	var node := _get_node(path, owner)
	if not node is TeleporterDestination:
		return null
	else:
		var destination:TeleporterDestination = node
		return destination
