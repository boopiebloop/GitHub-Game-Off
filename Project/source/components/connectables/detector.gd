# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name Detector
extends Area2D


signal detection
signal detection_lost

@export var _exempt_bodies:Array[Node2D] = []
@export var _connected_animation_tree:AnimationTree

var _detected_bodies:Array[Node2D] = []
var _ignoring_bodies:Array[Node2D] = []
var _detection:bool:
	get:
		return not _detected_bodies.is_empty()


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_body_entered)
	area_exited.connect(_on_body_exited)

func _on_body_entered(body:Node2D) -> void:
	if _exempt_bodies.has(body):
		_ignoring_bodies.append(body)
	else:
		_process_detected_body(body)

func _on_body_exited(body:Node2D) -> void:
	if _exempt_bodies.has(body):
		_ignoring_bodies.erase(body)
	else:
		_process_lost_body(body)

func _process_detected_body(body:Node2D) -> void:
	var initially_waiting := not has_detection()
	if not _detected_bodies.has(body):
		_detected_bodies.append(body)
	if initially_waiting:
		detection.emit()
		_update_animation_tree_parameters()

func _process_lost_body(body:Node2D) -> void:
	_detected_bodies.erase(body)
	if not has_detection():
		detection_lost.emit()
		_update_animation_tree_parameters()

func has_detection() -> bool:
	return _detection

func add_exemption(body:Node2D) -> void:
	if _exempt_bodies.has(body):
		return
	_exempt_bodies.append(body)
	if not _ignoring_bodies.has(body):
		_ignoring_bodies.append(body)
	if _detected_bodies.has(body):
		_process_lost_body(body)

func remove_exemption(body:Node2D) -> void:
	if not _exempt_bodies.has(body):
		return
	_exempt_bodies.erase(body)
	if _ignoring_bodies.has(body):
		_process_detected_body(body)

func _update_animation_tree_parameters() -> void:
	if _connected_animation_tree:
		_connected_animation_tree.set("parameters/conditions/detection", _detection)
		_connected_animation_tree.set("parameters/conditions/lost_detection", not _detection)
