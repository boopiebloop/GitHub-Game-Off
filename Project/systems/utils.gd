# ---------------------------------------------------------------------------------------------- #
##
# ---------------------------------------------------------------------------------------------- #


class_name Utils


static func middle_out_indices(count: int) -> Array[int]:
	var centre:int = floori(count / 2.0)
	var indices: Array[int] = []
	var right_indicies := range(centre, count)
	var left_indicies := range(0, centre)
	while indices.size() < count:
		if not right_indicies.is_empty():
			indices.append(right_indicies.pop_front())
		if not left_indicies.is_empty():
			indices.append(left_indicies.pop_back())
	return indices
