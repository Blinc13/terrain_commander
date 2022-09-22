extends RigidBody2D

signal Fire

var rocket = preload("res://scenes/projectile/Rocket.tscn")

export(float) var BARREL_MOVE_SPEED = 10.0
export(float) var ACCELERATION = 15.0
export(float) var STABLIZATION = 1.2
export(float) var FIRE_ENERGY = 500.0

onready var barrel = $Barrel
onready var trajectory = $Line2D

var target: Vector2
var target_angle: float = 0.0

var can_move: bool = true setget set_move
var can_fire: bool = false setget set_fire

func _input(event):
	if event is InputEventMouseMotion:
		target = get_global_mouse_position()
		target_angle = Projectile.calculate_velocity(position, get_global_mouse_position(), FIRE_ENERGY).angle() + PI/2
		
		update_trajectory()

func _physics_process(delta):
	calculate_barrel_angle()
	trajectory.global_rotation = 0
	
	if Input.is_action_just_pressed("fire") && can_fire:
		fire()

func _integrate_forces(state):
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



func calculate_barrel_angle():
	if !can_fire:
		return
	
	var weight = abs(target_angle - barrel.rotation) / BARREL_MOVE_SPEED
	var angle = lerp_angle(barrel.rotation, target_angle, weight)
	
	barrel.rotation = angle

func calculate_fire_position() -> Vector2:
	var angle = barrel.global_rotation
	var dir = Vector2(cos(angle), sin(angle)).rotated(-PI/2)
	
	return position + dir * 15

func fire():
	var node = rocket.instance()
	
	var node_params = Projectile.Parameters.new(calculate_fire_position(), target, FIRE_ENERGY)
	node.set_parameters(node_params)
	
	get_parent().add_child(node)
	emit_signal("Fire")

func update_trajectory():
	if !can_fire:
		return
	
	var fire_pos = calculate_fire_position()
	var velocity = Projectile.calculate_velocity(fire_pos, target, FIRE_ENERGY)
	
	trajectory.points = Projectile.calculate_projectile_path(98, velocity, 150)


func set_move(value: bool):
	can_move = value

func set_fire(value: bool):
	can_fire = value
	
	trajectory.visible = value


func _ready():
	var game = BaseNodes.game
	
	game.connect("MoveTurn", self, "set_move", [true])
	game.connect("FireTurn", self, "set_move", [false])
	
	game.connect("CanFire", self, "set_fire")
