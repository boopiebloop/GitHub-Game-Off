# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


class_name CombinationInputUI
extends Control


signal combination_inputted(inputted_combination:Array[int])


@export var _combination_textures:Array[Texture2D] = []:
	set(value):
		_combination_sprites = value
@export var _required_combination_amount:int = 1:
	set(value):
		_required_combination_amount = min(1, value)
@export var _inputted_combination:Array[int] = []
@export var _input_texture_button_packed_scene:PackedScene:
	set(value):
		if not value.can_instantiate():
			push_error("Invalid packed scene!")
			return
		var node := value.instantiate()
		if not node is TextureButton:
			push_error("Invalid packed scene!")
		else:
			_input_texture_button_packed_scene = value
		node.queue_free()

var _input_texture_buttons:Array[TextureButton] = []


func _update_input_texture_buttons() -> void:
	if _combination_textures.is_empty() or not _input_texture_button_packed_scene:
		for button in _input_texture_buttons:
			button.queue_free()
		_input_texture_buttons.clear()
		return
	for i in range(_required_combination_amount):
		var button:TextureButton = _input_texture_button_packed_scene.instantiate()
		button.texture
