extends KinematicBody2D

export(float) var BARREL_MOVE_SPEED = 10.0
export(float) var DRIVING_SPEED = 50.0
export(float) var ACCELERATION = 15.0
export(float) var DECELERATION = 10.0
export(float) var GRAVITY = 98.0

onready var barrel = $Barrel

var velocity: Vector2
var target_angle: float = 0.0

func _input(event):
	if event is InputEventMouseMotion:
		var p = Vector2.UP.angle_to(get_local_mouse_position().normalized())
		
		target_angle = clamp(p, -PI/2, PI/2)

func _physics_process(delta):
	var weight = abs(target_angle - barrel.rotation) / BARREL_MOVE_SPEED
	var angle = lerp_angle(barrel.rotation, target_angle, weight)
	
	barrel.rotation = angle
	
	
	var input = Input.get_vector("right", "left", "up", "down")
	
	if input.x != 0:
		velocity.x = clamp(velocity.x + (input.x * ACCELERATION * delta), -DRIVING_SPEED, DRIVING_SPEED)
	else:
		velocity.x -= clamp(velocity.x, -1, 1) * DECELERATION * delta
	
	if !self.is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
		rotation = get_floor_angle(Vector2.UP)
	
	move_and_slide(velocity, Vector2.UP)
