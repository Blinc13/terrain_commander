extends RigidBody2D

func _on_RigidBody2D_body_entered(body):
	get_node("../TerrainManager").cut_of($Sprite.polygon, body, position)
