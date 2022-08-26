extends KinematicBody2D

class_name Projectile

class Parameters:
	var s_pos: Vector2
	var t_pos: Vector2
	
	func _init(start_pos: Vector2, target_pos: Vector2):
		s_pos = start_pos
		t_pos = target_pos

const MAX_DISTANCE: float = 300.0

var terrain = BaseNodes.manager
var velocity: Vector2
var start_pos: Vector2
var target: Vector2

func set_parameters(params: Parameters):
	start_pos = params.s_pos
	target = params.t_pos
	
	var distance = start_pos-target
	
	var needed_y = MAX_DISTANCE - abs(distance.x)
	var needed_x = MAX_DISTANCE - needed_y
	
	velocity = Vector2(needed_x, -needed_y) / 2
	
	position = start_pos

func _physics_process(delta):
	var colision = move_and_collide(velocity * delta)
	velocity.y += 98.0 * delta
	
	if colision and colision.collider is TerrainFragment:
		var polygon = PolygonGenerator.generate_circle(25)
		
		terrain.cut_of(polygon, colision.collider, global_position)
		queue_free()
