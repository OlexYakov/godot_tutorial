extends Area2D

func is_coliding():
	return get_overlapping_areas().size() > 0
	
func get_softcolision_vect():
	var first_area = get_overlapping_areas()[0]
	var vect = first_area.global_position.direction_to(global_position)
	return vect.normalized()
