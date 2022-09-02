extends KinematicBody2D

class_name Projectile

class Parameters:
	var s_pos: Vector2
	var t_pos: Vector2
	
	func _init(start_pos: Vector2, target_pos: Vector2):
		s_pos = start_pos
		t_pos = target_pos

const FIRE_ENERGY: float = 300.0

var terrain = BaseNodes.manager
var velocity: Vector2
var start_pos: Vector2
var target: Vector2

func set_parameters(params: Parameters):
	start_pos = params.s_pos
	target = params.t_pos
	
	velocity = calculate_velocity(start_pos, target, FIRE_ENERGY)
	
	position = start_pos

func _physics_process(delta):
	var colision = move_and_collide(velocity * delta)
	velocity = update_velocity(velocity, 98.0, delta)
	
	if colision and colision.collider is TerrainFragment:
		var polygon = PolygonGenerator.generate_circle(25)
		
		terrain.cut_of(polygon, colision.collider, global_position)
		queue_free()

static func calculate_velocity(start_pos: Vector2, target_pos: Vector2, energy: float):
	var distance = start_pos.x - target_pos.x
	
	if distance == 0:
		return Vector2.UP * energy
	
	var needed_y = energy - abs(distance)
	var needed_x = (energy - needed_y) * (distance / abs(distance))
	
	return Vector2(-needed_x, -needed_y) / 2

static func update_velocity(vel: Vector2, grav: float, dlt: float) -> Vector2:
	vel.y += grav * dlt
	
	return vel
