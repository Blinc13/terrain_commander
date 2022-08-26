extends KinematicBody2D

class_name Projectile

var terrain: TerrainManager
var velocity: Vector2
var start_pos: Vector2
var target = Vector2.RIGHT * 100

func _init():
	start_pos = position
	position.x+=1

func _physics_process(delta):
	var x_pos = calculate_point_on_path(start_pos.x, target.x, position.x)
	x_pos = calculate_Y_for_point_on_path(x_pos)
	
	var colision = move_and_collide(Vector2.RIGHT + Vector2(0, x_pos))
	
	if colision:
		var polygon = PolygonGenerator.generate_circle(25)
		
		terrain.cut_of(polygon, colision.collider, global_position)
		queue_free()

# Returns value betwen 0 and 1
static func calculate_point_on_path(start_pos: float, target_pos: float, pos: float) -> float:
	return (pos - start_pos) / target_pos

# Apply sin() for value and some other calculations
static func calculate_Y_for_point_on_path(point: float):
	return -sin(point * PI * 1.9)
