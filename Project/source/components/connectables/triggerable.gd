# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name Triggerable
extends Node


signal triggered

@warning_ignore("unused_private_class_variable")
@export_tool_button("Trigger") var _trigger_callable:Callable = trigger


func trigger() -> void:
	triggered.emit()
