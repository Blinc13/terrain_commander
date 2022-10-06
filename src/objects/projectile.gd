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


var explosion_effect = preload("res://scenes/misc/effects/RocketExplosion.tscn")

onready var sound_player = $StartSoundPlayer
onready var terrain = BaseNodes.terrain_manager
onready var game = BaseNodes.game

var velocity: Vector2

var start_pos: Vector2
var target: Vector2

remote var puppet_pos: Vector2
remote var puppet_rot: float

func set_parameters(params: Parameters):
	start_pos = params.s_pos
	target = params.t_pos
	
	velocity = calculate_velocity(start_pos, target, params.en)
	
	position = start_pos

func _ready():
	sound_player.play(0.0) # After adding to scene_tree play sound

func _physics_process(delta):
	if !is_network_master():
		position = puppet_pos
		rotation = puppet_rot
		
		return
	
	var colision = move_and_collide(velocity * delta)
	
	if colision:
		explode(25, 5)
		
		rpc("destroy_object_local")
	
	velocity = update_velocity(velocity, 98.0, delta)
	rotation = velocity.angle()
	
	rset_unreliable("puppet_pos", position)
	rset_unreliable("puppet_rot", rotation)

func explode(radius: float, randomness: float):
	# Generating needed polygons
	var polygon = PolygonGenerator.generate_circle(radius, randomness)
	var moved_polygon = PolygonGenerator.move_polygon(polygon, global_position)
	
	# Cuting terrain
	terrain.cut_of(polygon, global_position)
	
	# Collecting info about all objects, affected by explosion(All objects in explosion shape)
	var shape = terrain.create_shape(moved_polygon) # Reused old code
	var affected_objects = Misc.get_phys_objects_in_shape(shape, get_world_2d(), 1)
	
	# For every object call damage
	for object_dict in affected_objects:
		object_dict["collider"].damage()
	
	# Spawn explosion effect on all clients
	rpc("spawn_effect", global_position, radius)


remotesync func spawn_effect(pos: Vector2, radius: float):
	var effect = explosion_effect.instance()
	
	game.add_child(effect)
	effect.init(pos, radius)

remotesync func destroy_object_local():
	queue_free()

# Static math funcs
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
