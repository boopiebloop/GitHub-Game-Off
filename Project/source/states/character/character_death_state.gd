# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name CharacterDeathState
extends CharacterState


## Required dependency for knowing when the [Player] died.
@export var _health_component:HealthComponent


var _died:bool = false



func _get_default_animation_name() -> String:
	return "died"


func _get_required_dependency_properties() -> Array[String]:
	return DSM.append_and_return(super(), "_health_component")


func _ready() -> void:
	super()
	if _health_component:
		_health_component.died.connect(_on_died)


func _start_running() -> void:
	super()
	character_body.velocity.x = 0
	get_parent().process_mode = Node.PROCESS_MODE_DISABLED
	await _wait_for_animation_completion()
	character_body.queue_free()


func _on_died() -> void:
	_died = true


func can_run() -> bool:
	if _died:
		return true
	else:
		return false
