extends RigidBody2D

var rocket = preload("res://scenes/projectile/Rocket.tscn")

export(float) var BARREL_MOVE_SPEED = 10.0
export(float) var ACCELERATION = 15.0
export(float) var STABLIZATION = 1.2

onready var barrel = $Barrel

var target: Vector2
var target_angle: float = 0.0

func _input(event):
	if event is InputEventMouseMotion:
		target = get_global_mouse_position()
		
		target_angle = Projectile.calculate_velocity(position, get_global_mouse_position(), Projectile.FIRE_ENERGY).angle() + PI/2

func _physics_process(delta):
	calculate_barrel_angle()
	
	if Input.is_action_just_pressed("fire"):
		fire()

func _integrate_forces(state):
	# Corporate values
	var angle = Vector2(cos(rotation), sin(rotation))
	
	# Stabilisating
	var offset = angle.dot(Vector2.UP)
	
	var direction_to_rot = (offset / abs(offset))
	
	state.apply_torque_impulse(STABLIZATION * direction_to_rot)
	
	
	# Controls
	if state.get_contact_count() > 0:
		var input = Input.get_vector("left", "right", "up", "down")
		var normal = position.direction_to(state.get_contact_local_position(0))
		
		# If contact point is under the tank, apply impulse
		if abs(angle.dot(normal)) < 0.69:
			var move_dir = input.rotated(normal.angle() + PI/2)
			
			state.apply_impulse(Vector2.DOWN * 5, move_dir * ACCELERATION)



func calculate_barrel_angle():
	var weight = abs(target_angle - barrel.rotation) / BARREL_MOVE_SPEED
	var angle = lerp_angle(barrel.rotation, target_angle, weight)
	
	barrel.rotation = angle

func fire():
	var node = rocket.instance()
	
	var angle = barrel.global_rotation
	var dir = Vector2(cos(angle), sin(angle)).rotated(-PI/2)
	
	var node_params = Projectile.Parameters.new(position + dir * 15, target)
	node.set_parameters(node_params)
	
	get_parent().add_child(node)

