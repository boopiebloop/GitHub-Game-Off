# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name Selectable
extends Detector


signal selected_by_body(body:Node2D)
signal selected

func _ready() -> void:
	super()
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_value(4, true)
	set_collision_mask_value(5, true)

func select(body:Node2D) -> void:
	selected.emit()
	if body:
		selected_by_body.emit(body)
