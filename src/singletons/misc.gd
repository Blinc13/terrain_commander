extends Node

func get_phys_objects_in_shape(shape: Shape2D, world: World2D, layer: int) -> Array:
	var phys_state = Physics2DServer.space_get_direct_state(world.space)
	
	var params = Physics2DShapeQueryParameters.new()
	
	params.shape_rid = shape.get_rid()
	params.collision_layer = 1 << layer
	
	return phys_state.intersect_shape(params)
