# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name TiledContainerPolygon
extends Polygon2D




# --- Signals --- #
																									
# ----------------------------------------------------------------------------------------------- #


# ...




# --- Properties --- #
																									
# ----------------------------------------------------------------------------------------------- #


const SURROUNDING_CELL_POSITION_OFFSETS:Array[Vector2i] = [
	Vector2i.UP,
	Vector2i(1, -1),
	Vector2i.RIGHT,
	Vector2i(1, 1),
	Vector2i.DOWN,
	Vector2i(-1, 1),
	Vector2i.LEFT,
	Vector2i(-1, -1),
]

const MAX_CONTAINER_CELLS:int = 100
const MAX_CELL_CHECKS:int = 100



# References:

@export var _container_tile_map:TileMapLayer


# Parameters:

# ...

# Variables:

var _fillable_cell_positions:Array[Vector2i] = []



# --- Methods --- #
																									
# ----------------------------------------------------------------------------------------------- #


func _update_container_data() -> void:
	_fillable_cell_positions = _get_fillable_cell_positions()
	_fillable_cell_positions.sort_custom(func(a:Vector2i, b:Vector2i) -> bool:
		if a.y < b.y:
			return true
		else:
			return false)


func _get_fillable_cell_positions() -> Array[Vector2i]:
	
	var container_cell_position:Array[Vector2i] = _container_tile_map.get_used_cells()
	
	# 1. Get bounding box of container cell positions (with 1 cell padding).
	
	var bounding_box := Rect2i()
	for cell_position in container_cell_position:
		if bounding_box.position.x > cell_position.x:
			bounding_box.position.x = cell_position.x
		if bounding_box.position.y > cell_position.y:
			bounding_box.position.y = cell_position.y
		if bounding_box.end.x < cell_position.x:
			bounding_box.end.x = cell_position.x
		if bounding_box.end.y < cell_position.y:
			bounding_box.end.y = cell_position.y
	bounding_box = bounding_box.grow(1) # Adds padding.
	
	# 2. Get all cell positions outside the container but within the bounding box.
	
	var outside_cell_positions:Array[Vector2i] = []
	var checking_cell_position_queue:Array[Vector2i] = [bounding_box.position]
	
	while not checking_cell_position_queue.is_empty():
		var checking_cell_position:Vector2i = checking_cell_position_queue.pop_front()
		for adjacent_cell_offset:Vector2i in [Vector2i.UP, Vector2i.LEFT, Vector2i.RIGHT, 
			Vector2i.DOWN]:
				var adjacent_cell_position := checking_cell_position + adjacent_cell_offset
				if not bounding_box.has_point(adjacent_cell_position):
					continue
				elif ((outside_cell_positions.has(adjacent_cell_position))
					or (container_cell_position.has(adjacent_cell_position))):
						continue
				else:
					outside_cell_positions.append(adjacent_cell_position)
					checking_cell_position_queue.append(adjacent_cell_position)
	
	# 3. Return all container positions as the positons that aren't outside the enclosed area or
	# part of the enclosing positions.
	
	var fillable_cell_positions:Array[Vector2i] = []
	for x in range(bounding_box.position.x + 1, bounding_box.end.x):
		for y in range(bounding_box.position.y + 1, bounding_box.end.y):
			var cell_position := Vector2i(x, y)
			if container_cell_position.has(cell_position):
				continue
			elif outside_cell_positions.has(cell_position):
				continue
			else:
				fillable_cell_positions.append(cell_position)
	
	return fillable_cell_positions


func _get_surrounding_cell_positions(cell_position:Vector2i) -> Array[Vector2i]:
	var surrounding_cell_positions:Array[Vector2i] = []
	for offset in SURROUNDING_CELL_POSITION_OFFSETS:
		var adjacent_cell_position:Vector2i = cell_position + offset
		surrounding_cell_positions.append(adjacent_cell_position)
	return surrounding_cell_positions
