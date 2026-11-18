# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name FillableComponent
extends TileMapLayer




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

@export var _enclosing_tile_map_layer:TileMapLayer


# Parameters:

@export var _filled_percentage:float = 0:
	set(value):
		_filled_percentage = clampf(value, 0, 1)
		_update_container_fill()
@export var _filled_tile_source_index:int
@export var _filled_tile_atlas_coords:Vector2i 


# Variables:

var _container_cell_positions:Array[Vector2i] = []



# --- Methods --- #
																									
# ----------------------------------------------------------------------------------------------- #


func _ready() -> void:
	_container_cell_positions = _get_container_cell_positions()
	_container_cell_positions.sort_custom(func(a:Vector2i, b:Vector2i) -> bool:
		if a.y < b.y:
			return true
		else:
			return false)
	_update_container_fill()


func _get_container_cell_positions() -> Array[Vector2i]:
	
	var enclosing_cell_positions:Array[Vector2i] = _enclosing_tile_map_layer.get_used_cells()
	
	# 1. Get bounding box of enclosing cell positions.
	
	var min_checking_cell := Vector2i.MAX
	var max_checking_cell := Vector2i.MIN
	for cell_position in enclosing_cell_positions:
		if min_checking_cell.x > cell_position.x:
			min_checking_cell.x = cell_position.x
		if max_checking_cell.x < cell_position.x:
			max_checking_cell.x = cell_position.x
		if min_checking_cell.y > cell_position.y:
			min_checking_cell.y = cell_position.y
		if max_checking_cell.y < cell_position.y:
			max_checking_cell.y = cell_position.y
	
	# Add one to make sure they will be outside the container.
	min_checking_cell -= Vector2i.ONE
	max_checking_cell += Vector2i.ONE
	
	# 2. Get all cell positions outside the enclosed area.
	
	var outside_cell_positions:Array[Vector2i] = []
	var checking_cell_position_queue:Array[Vector2i] = [min_checking_cell]
	
	while not checking_cell_position_queue.is_empty():
		var checking_cell_position:Vector2i = checking_cell_position_queue.pop_front()
		for adjacent_cell_offset:Vector2i in [Vector2i.UP, Vector2i.LEFT, Vector2i.RIGHT, 
			Vector2i.DOWN]:
				var adjacent_cell_position := checking_cell_position + adjacent_cell_offset
				if ((adjacent_cell_position.x < min_checking_cell.x)
					or (adjacent_cell_position.y < min_checking_cell.y)
					or (adjacent_cell_position.x > max_checking_cell.x)
					or (adjacent_cell_position.y > max_checking_cell.y)):
						continue
				elif ((outside_cell_positions.has(adjacent_cell_position))
					or (enclosing_cell_positions.has(adjacent_cell_position))):
						continue
				else:
					outside_cell_positions.append(adjacent_cell_position)
					checking_cell_position_queue.append(adjacent_cell_position)
	
	# 3. Return all container positions as the positons that aren't outside the enclosed area or
	# part of the enclosing positions.
	
	var container_cell_positions:Array[Vector2i] = []
	for x in range(min_checking_cell.x + 1, max_checking_cell.x):
		for y in range(min_checking_cell.y + 1, max_checking_cell.y):
			var cell_position := Vector2i(x, y)
			if enclosing_cell_positions.has(cell_position):
				continue
			elif outside_cell_positions.has(cell_position):
				continue
			else:
				container_cell_positions.append(cell_position)
	
	return container_cell_positions


func _get_surrounding_cell_positions(cell_position:Vector2i) -> Array[Vector2i]:
	var surrounding_cell_positions:Array[Vector2i] = []
	for offset in SURROUNDING_CELL_POSITION_OFFSETS:
		var adjacent_cell_position:Vector2i = cell_position + offset
		surrounding_cell_positions.append(adjacent_cell_position)
	return surrounding_cell_positions


func _update_container_fill() -> void:
	if _container_cell_positions.is_empty():
		return
	var min_container_cell_y_level:int = _container_cell_positions.front().y - 1
	var max_container_cell_y_level:int = _container_cell_positions.back().y
	var filling_y:int = floori(lerpf(max_container_cell_y_level, min_container_cell_y_level, 
		_filled_percentage))
	for cell_position in _container_cell_positions:
		if cell_position.y > filling_y:
			set_cell(cell_position, _filled_tile_source_index, _filled_tile_atlas_coords)
		else:
			erase_cell(cell_position)
