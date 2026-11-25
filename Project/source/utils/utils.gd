# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name Utils


static func get_children_recursively(parent:Node) -> Array[Node]:
	var children:Array[Node] = parent.get_children()
	for child in children:
		children.append_array(get_children_recursively(child))
	return children

static func remove_invalid_entries(dictionary:Dictionary) -> void:
	for key:Variant in dictionary.keys():
		if is_instance_valid(key):
			continue
		else:
			dictionary.erase(key)
