# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name SandContainer
extends Polygon2D


signal polygon_changed


@export var _total_volume:float:
	get:
		return _get_total_volume()
@export var _filled_volume:float = 0:
	set(value):
		_filled_volume = clampf(value, 0, _total_volume)
		_filled_percentage = _filled_volume / _total_volume
@export var _filled_percentage:float = 0:
	set(value):
		_filled_percentage = clampf(value, 0, 1)
		_filled_volume = _total_volume * _filled_percentage
		_update_shader()
@export var _flow_ports:Array[SandFlowPort] = []

@onready var _previous_polygon_hash:int = hash(polygon)
var _max_point:Vector2
var _min_point:Vector2


func _ready() -> void:
	pass

func _get_min_y() -> float:
	var min_y:float = INF
	for point in polygon:
		if point.y < min_y:
			min_y = point.y
	return min_y

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
	if material and material is ShaderMaterial:
		var shader_material:ShaderMaterial = material
		var max_y:float = -INF
		var min_y:float = INF
		for point in polygon:
			if point.y > max_y:
				max_y = point.y
			if point.y < min_y:
				min_y = point.y
		shader_material.set_shader_parameter("min_y", min_y)
		shader_material.set_shader_parameter("max_y", max_y)

func _on_polygon_changed() -> void:
	_total_volume = _get_total_volume()
	_max_point = -Vector2.INF
	_min_point = Vector2.INF
	for point in polygon:
		if point.x > _max_point.x:
			_max_point.x = point.x
		if point.y > _max_point.y:
			_max_point.x = point.x
		if point.x < _min_point.x:
			_min_point.x = point.x
		if point.y < _min_point.y:
			_min_point.x = point.y

func _update_shader() -> void:
	if not material or not material is ShaderMaterial:
		return
	var shader_material:ShaderMaterial = material
	shader_material.set_shader_parameter("fill_percentage", _filled_percentage)
	shader_material.set_shader_parameter("min_y", _min_point.y)
	shader_material.set_shader_parameter("max_y", _max_point.y)

func _update_flow() -> void:
	pass
