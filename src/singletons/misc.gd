extends Node

func calculate_projectile_path(gravity: float, initial_velocity: Vector2, points_count: int) -> PoolVector2Array:
	var position = Vector2.ZERO
	var velocity = initial_velocity
	
	var output = PoolVector2Array()
	
	for x in range(0, points_count):
		output.push_back(position)
		
		position += velocity * 0.1
		velocity = Projectile.update_velocity(velocity, gravity, 0.1)
	
	return output
