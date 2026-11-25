# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name SandContainer
extends Polygon2D


signal polygon_changed


@export var _total_volume:float:
	set(value):
		_filled_percentage = _filled_percentage
@export var _filled_volume:float = 0:
	set(value):
		if _filled_volume == value:
			return
		_filled_volume = clampf(value, 0, _total_volume)
		_filled_percentage = _filled_volume / _total_volume
@export var _filled_percentage:float = 0:
	set(value):
		if value == _filled_percentage:
			return
		_filled_percentage = clampf(value, 0, 1)
		_filled_volume = _total_volume * _filled_percentage
		_update_shader()

@onready var _previous_polygon_hash:int
var _max_point:Vector2:
	set(value):
		_max_point = value
		_update_shader()
var _min_point:Vector2:
	set(value):
		_min_point = value
		_update_shader()


func _ready() -> void:
	polygon_changed.connect(_on_polygon_changed)

func _get_total_volume() -> float:
	var twice_area := 0.0
	for i in range(polygon.size()):
		twice_area += polygon[i].cross(polygon[(i + 1) % polygon.size()])
	return abs(twice_area) * 0.5

func _process(_delta:float) -> void:
	var new_polygon_hash:int = hash(polygon)
	if not _previous_polygon_hash == new_polygon_hash:
		_previous_polygon_hash = new_polygon_hash
		polygon_changed.emit()

func _on_polygon_changed() -> void:
	_total_volume = _get_total_volume()
	_max_point = -Vector2.INF
	_min_point = Vector2.INF
	for point in polygon:
		if point.x > _max_point.x:
			_max_point.x = point.x
		if point.y > _max_point.y:
			_max_point.y = point.y
		if point.x < _min_point.x:
			_min_point.x = point.x
		if point.y < _min_point.y:
			_min_point.y = point.y

func _update_shader() -> void:
	if not material or not material is ShaderMaterial:
		return
	var shader_material:ShaderMaterial = material
	shader_material.set_shader_parameter("fill_percentage", _filled_percentage)
	shader_material.set_shader_parameter("min_y", _min_point.y)
	shader_material.set_shader_parameter("max_y", _max_point.y)

func get_free_volume() -> float:
	return _total_volume - _filled_volume

func get_filled_volume() -> float:
	return _filled_volume

func add_sand(volume:float) -> float:
	var added_volume:float = min(volume, _total_volume - _filled_volume)
	_filled_volume += added_volume
	return added_volume

func take_sand(volume:float) -> float:
	var removing_volume:float = max(0, _filled_volume - volume)
	_filled_volume -= removing_volume
	return removing_volume
