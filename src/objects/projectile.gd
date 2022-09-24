extends KinematicBody2D

class_name Projectile

class Parameters:
	var s_pos: Vector2
	var t_pos: Vector2
	var en: float
	
	func _init(start_pos: Vector2, target_pos: Vector2, energy: float):
		s_pos = start_pos
		t_pos = target_pos
		en = energy


onready var terrain = BaseNodes.terrain_manager

var velocity: Vector2

var start_pos: Vector2
var target: Vector2


func set_parameters(params: Parameters):
	start_pos = params.s_pos
	target = params.t_pos
	
	velocity = calculate_velocity(start_pos, target, params.en)
	
	position = start_pos

func _physics_process(delta):
	var colision = move_and_collide(velocity * delta)
	
	velocity = update_velocity(velocity, 98.0, delta)
	
	rotation = velocity.angle()
	
	if colision and colision.collider is TerrainFragment:
		explode_terrain(global_position)
		
		queue_free()

func explode_terrain(pos: Vector2):
	var polygon = PolygonGenerator.generate_circle(25)
	
	terrain.cut_of(polygon, pos)


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

static func calculate_projectile_path(gravity: float, initial_velocity: Vector2, points_count: int) -> PoolVector2Array:
	var position = Vector2.ZERO
	var velocity = initial_velocity
	
	var output = PoolVector2Array()
	
	for _x in range(0, points_count):
		output.push_back(position)
		
		position += velocity * 0.1
		velocity = update_velocity(velocity, gravity, 0.1)
	
	return output
