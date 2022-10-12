extends RigidBody2D

class_name Player

signal Fire
signal Destoyed

var rocket = preload("res://scenes/projectiles/Rocket.tscn")

export(float) var BARREL_MOVE_SPEED = 10.0
export(float) var ACCELERATION = 150.0
export(float) var STABLIZATION = 3.0
export(float) var FIRE_ENERGY = 500.0

onready var barrel: Node2D = $Barrel
onready var trajectory: Node2D = get_node_or_null("Line2D")

var target: Vector2
var target_angle: float = 0.0

var can_move: bool = true setget set_move
var can_fire: bool = false setget set_fire

remote var puppet_pos: Vector2
remote var puppet_rot: float
remote var puppet_barrel_rot: float

func _input(event):
	if !is_network_master():
		return
	
	if event is InputEventMouseMotion:
		target = get_global_mouse_position()
		target_angle = Projectile.calculate_velocity(position, get_global_mouse_position(), FIRE_ENERGY).angle() + PI/2
	
		update_trajectory()

func _physics_process(_delta):
	if !is_network_master():
		position = puppet_pos
		rotation = puppet_rot
		barrel.rotation = puppet_barrel_rot
		
		return
	
	calculate_barrel_angle()
	trajectory.global_rotation = 0
	
	if can_fire && Input.is_action_just_pressed("fire"):
		fire()
	
	rset_unreliable("puppet_pos", position)
	rset_unreliable("puppet_rot", rotation)
	rset_unreliable("puppet_barrel_rot", barrel.rotation)

func _integrate_forces(state):
	if !is_network_master():
		return
	
	# Corporate values
	var angle = Vector2(cos(rotation), sin(rotation))
	
	# Stabilisating
	var offset = angle.dot(Vector2.UP)
	var direction_to_rot = 0
	
	if offset != 0:
		direction_to_rot = (offset / abs(offset))
	
	state.apply_torque_impulse(STABLIZATION * direction_to_rot)
	
	
	# Controls
	if state.get_contact_count() > 0 and can_move:
		var input = Input.get_vector("left", "right", "up", "down")
		var normal = position.direction_to(state.get_contact_local_position(0))
		
		# If contact point is under the tank, apply impulse
		if abs(angle.dot(normal)) < 0.69:
			var move_dir = input.rotated(normal.angle() + PI/2)
			
			state.apply_impulse(Vector2.DOWN * 5, move_dir * ACCELERATION)

# Server informs player about his damage by this function
func damage():
	var id = int(name)
	
	if id == 1:
		damage_client()
	else:
		rpc_id(id, "damage_client") # So far there will only be 1 life

remote func damage_client():
	emit_signal("Destoyed")


func calculate_barrel_angle():
	var weight = abs(target_angle - barrel.rotation) / BARREL_MOVE_SPEED
	var angle = lerp_angle(barrel.rotation, target_angle, weight)
	
	barrel.rotation = angle

func calculate_fire_position() -> Vector2:
	var angle = barrel.global_rotation
	var dir = Vector2(cos(angle), sin(angle)).rotated(-PI/2)
	
	return position + dir * 15

func update_trajectory():
	var fire_pos = calculate_fire_position()
	var velocity = Projectile.calculate_velocity(fire_pos, target, FIRE_ENERGY)
	
	trajectory.points = Projectile.calculate_projectile_path(98, velocity, 150)


func fire():
	rpc("spawn_rocket_local", calculate_fire_position(), target, FIRE_ENERGY)
	
	emit_signal("Fire")
	set_fire(false) # Player can make only one shot

remotesync func spawn_rocket_local(start_pos: Vector2, target_pos: Vector2, energy: float):
	var node = rocket.instance()
	
	var node_params = Projectile.Parameters.new(start_pos, target_pos, energy)
	node.set_parameters(node_params)
	
	node.set_network_master(1) # Server is master of all rockets
	
	BaseNodes.game.add_child(node)


func set_move(value: bool):
	can_move = value

func set_fire(value: bool):
	can_fire = value
	
	trajectory.visible = value

func _ready():
	if !is_network_master():
		return
	
	var game = BaseNodes.game
	
	game.connect("MoveTurn", self, "set_move", [true])
	game.connect("FireTurn", self, "set_move", [false])
	
	game.connect("CanFire", self, "set_fire")
	
	connect("Destoyed", game, "player_destoryed")
