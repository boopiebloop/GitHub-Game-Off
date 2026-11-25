# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


class_name SandFlowLink
extends Line2D


@export var flow_rate:float
@export var input_container:SandContainer
@export var output_container:SandContainer


func do_flow(delta:float) -> void:
	var flowable_volume := minf(minf(input_container.get_free_volume(), flow_rate * delta), 
		output_container.get_free_volume())
	input_container.take_sand(flowable_volume)
	output_container.add_sand(flowable_volume)
