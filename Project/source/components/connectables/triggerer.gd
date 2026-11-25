# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


@tool
class_name Triggerer
extends Triggerable


@export var _linked_triggerables:Array[Triggerable]

@warning_ignore("unused_private_class_variable")
@export_tool_button("Trigger Linked Triggerables") 
var _trigger_linked_triggerables_callable:Callable = trigger_linked_triggerables

func trigger_linked_triggerables() -> void:
	for linked_trigger in _linked_triggerables:
		linked_trigger.trigger()
