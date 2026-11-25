# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name Selector
extends Area2D


@export var _selecting_body:Node2D
var _found_selectables:Array[Selectable]
var _hovering_selectable:Selectable


func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_value(5, true)
	set_collision_mask_value(4, true)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		_do_selection()

func _on_area_entered(area:Area2D) -> void:
	if area is Selectable:
		var selectable:Selectable = area
		_on_selectable_found(selectable)

func _on_area_exited(area:Area2D) -> void:
	if area is Selectable:
		var selectable:Selectable = area
		_on_selectable_lost(selectable)

func _on_selectable_found(selectable:Selectable) -> void:
	if _found_selectables.has(selectable):
		return
	_found_selectables.append(selectable)
	selectable.add_exemption(self)

func _on_selectable_lost(selectable:Selectable) -> void:
	_found_selectables.erase(selectable)
	if _hovering_selectable == selectable:
		_hovering_selectable = _get_closest_selectable()
	else:
		selectable.remove_exemption(self)

func _get_closest_selectable() -> Selectable:
	if _found_selectables.is_empty():
		return null
	else:
		var closest_selectable:Selectable
		var closest_selectable_distance:float = INF
		for selectable in _found_selectables:
			var distance:float = selectable.global_position.distance_to(get_global_mouse_position())
			if distance < closest_selectable_distance:
				closest_selectable = selectable
		return closest_selectable

func _do_selection() -> void:
	if not _hovering_selectable:
		return
	else:
		_hovering_selectable.select(_selecting_body)

func _get_configuration_warnings() -> PackedStringArray:
	if not _selecting_body:
		return ["No '_selecting_body' set!"]
	else:
		return []

func _process(_delta:float) -> void:
	if _found_selectables.is_empty():
		return
	else:
		var closest_selectable := _get_closest_selectable()
		if _hovering_selectable and not _hovering_selectable == closest_selectable:
			_hovering_selectable.add_exemption(self)
		closest_selectable.remove_exemption(self)
		_hovering_selectable = closest_selectable
