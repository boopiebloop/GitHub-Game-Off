# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


class_name AnimationTreeDebugger
extends AnimationTree




# --- Signals --- #
																									
# ----------------------------------------------------------------------------------------------- #


# ...




# --- Properties --- #
																									
# ----------------------------------------------------------------------------------------------- #


# References:

# ...


# Variables:

# ...




# --- Methods --- #
																									
# ----------------------------------------------------------------------------------------------- #


func _process(_delta: float) -> void:
	var playback:AnimationNodeStateMachinePlayback = get("parameters/playback")
	@warning_ignore("unused_variable")
	var current_node := playback.get_current_node()
	pass
