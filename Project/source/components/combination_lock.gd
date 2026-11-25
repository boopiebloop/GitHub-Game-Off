# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name CombinationLock
extends Activator


@export var _input_sprites:Array[Sprite2D] = []:
	set(value):
		if value.size() > _solution.size():
			push_error("Can't have more input sprites than solution size!")
		_input_sprites = value
		_update_input_sprites()
@export var _blank_texture:Texture2D:
	set(value):
		_blank_texture = value
		_update_input_sprites()
@export var _combination_variant_textures:Array[Texture2D] = []:
	set(value):
		_combination_variant_textures = value
		_solution = _solution
@export var _hover_sprite_material:ShaderMaterial
@export var _solution:Array[int] = []:
	set(value):
		if _combination_variant_textures.is_empty():
			push_error("No combination variants! Please add before setting solution.")
			return
		_solution.clear()
		_solution.resize(value.size())
		for i in range(value.size()):
			_solution[i] = clampi(value[i], 0, _combination_variant_textures.size()-1)
		_inputs = _inputs

@export var _attempt_check_cooldown_duration:float = 1:
	set(value):
		_attempt_check_cooldown_duration = max(0, value)
@export var _attempts_left:int = 1:
	set(value):
		_attempts_left = max(-1, value)
@export var _inputs:Array[int] = []:
	set(value):
		_inputs.clear()
		_inputs.resize(_solution.size())
		_inputs.fill(-1)
		for i in range(value.size()):
			if i >= _solution.size():
				break
			_inputs[i] = clampi(value[i], -1, _combination_variant_textures.size()-1)
		_update_input_sprites()
@export var _selected_input_index:int = 0:
	set(value):
		if not _are_parameters_valid():
			_selected_input_index = -1
		else:
			_selected_input_index = clampi(value % _inputs.size(), 0, _inputs.size())
			_selected_input_value = _inputs[_selected_input_index]
			_update_input_sprites()
@export var _selected_input_value:int = -1:
	set(value):
		if not _are_parameters_valid():
			_selected_input_value = -1
		else:
			_selected_input_value = clampi(value % _combination_variant_textures.size(), -1, _combination_variant_textures.size()-1)
			_inputs[_selected_input_index] = _selected_input_value
			_update_input_sprites()

@export var _selecting_inputs:bool = false:
	set(value):
		if not _are_parameters_valid():
			push_error("Can't select inputs if parameters are invalid!")
			return
		_selecting_inputs = value
		if not Engine.is_editor_hint():
			get_tree().paused = _selecting_inputs
			if _selecting_inputs:
				_attempt_check_cooldown = _attempt_check_cooldown_duration
				process_mode = Node.PROCESS_MODE_WHEN_PAUSED
				_selected_input_index = 0
				_selected_input_value = _inputs.front()
			else:
				process_mode = Node.PROCESS_MODE_INHERIT
		for sprite in _input_sprites:
			sprite.visible = _selecting_inputs
@export var _solved:bool = false:
	set(value):
		_solved = value
		if _solved:
			_selecting_inputs = false
			activate()

var _attempt_check_cooldown:float:
	set(value):
		_attempt_check_cooldown = max(0, value)


func _ready() -> void:
	_selecting_inputs = false
	_update_input_sprites()

func _are_parameters_valid() -> bool:
	if _combination_variant_textures.is_empty():
		return false
	elif _solution.is_empty():
		return false
	elif not _inputs.size() == _input_sprites.size():
		return false
	else:
		return true

func _update_input_sprites() -> void:
	for sprite in _input_sprites:
		sprite.texture = _blank_texture
	if not _are_parameters_valid():
		return
	for i in range(_inputs.size()):
		var sprite := _input_sprites[i]
		var combination_value := _inputs[i]
		if combination_value == -1:
			sprite.texture = _blank_texture
		else:
			sprite.texture = _combination_variant_textures[combination_value]
		if _selected_input_index == i:
			sprite.material = _hover_sprite_material
		else:
			sprite.material = null

func _input(event: InputEvent) -> void:
	if not _selecting_inputs or Engine.is_editor_hint():
		return
	elif event.is_action_pressed("move_left"):
		_selected_input_index -= 1
	elif event.is_action_pressed("move_right"):
		_selected_input_index += 1
	elif event.is_action_pressed("select_up"):
		_selected_input_value += 1 
	elif event.is_action_pressed("select_down"):
		_selected_input_value -= 1
	elif event.is_action_pressed("select"):
		_check_attempt()
	elif event.is_action_pressed("cancel"):
		_selecting_inputs = false

func _check_attempt() -> void:
	if _attempt_check_cooldown > 0:
		return
	var successful:bool = true
	for i in range(_inputs.size()):
		if not _inputs[i] == _solution[i]:
			successful = false
			break
	if not successful:
		_attempts_left -= 1
	else:
		await get_tree().process_frame
		_solved = true

func _get_configuration_warnings() -> PackedStringArray:
	if not _are_parameters_valid():
		return ["Invalid parameters!"]
	else:
		return []

func _on_selected() -> void:
	if _solved or _attempts_left == 0:
		return
	else:
		_selecting_inputs = true

func _process(delta: float) -> void:
	if _attempt_check_cooldown > 0:
		_attempt_check_cooldown -= delta
