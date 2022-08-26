extends KinematicBody2D

class_name Projectile

class Parameters:
	var s_pos: Vector2
	var t_pos: Vector2
	
	func _init(start_pos: Vector2, target_pos: Vector2):
		s_pos = start_pos
		t_pos = target_pos


var terrain = BaseNodes.manager
var velocity: Vector2
var start_pos: Vector2
var target: Vector2

func set_parameters(params: Parameters):
	start_pos = params.s_pos
	target = params.t_pos
	
	position = start_pos

func _physics_process(delta):
	var x_pos = calculate_point_on_path(start_pos.x, target.x, position.x)
	print(start_pos, " ", target, " ", position)
	x_pos = calculate_Y_for_point_on_path(x_pos)
	
	var colision = move_and_collide(start_pos.direction_to(target))
	position.y += x_pos
	
	if colision:
		var polygon = PolygonGenerator.generate_circle(25)
		
		terrain.cut_of(polygon, colision.collider, global_position)
		queue_free()

# Returns value betwen 0 and 1
static func calculate_point_on_path(start_pos: float, target_pos: float, pos: float) -> float:
	return abs(pos - start_pos) / abs(target_pos)

# Apply sin() for value and some other calculations
static func calculate_Y_for_point_on_path(point: float):
	return -sin(clamp(point, 0, 1) * PI * 1.25)
