extends KinematicBody2D

class_name Projectile

var terrain: TerrainManager
var velocity: Vector2

func _physics_process(delta):
	var colision = move_and_collide(velocity)
	
	if colision:
		var polygon = PolygonGenerator.generate_circle(56)
		
		terrain.cut_of(polygon, colision.collider, global_position)
		queue_free()
