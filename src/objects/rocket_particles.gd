extends Particles2D

func init(position: Vector2, radius: float):
	(process_material as ParticlesMaterial).emission_ring_radius = radius
	global_position = position
	
	$QueueFree_timer.start(lifetime)
