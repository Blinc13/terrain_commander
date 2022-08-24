extends Node


func generate_circle(radius: float) -> PoolVector2Array:
	var output = PoolVector2Array()
	
	for x in range(0, 380, 24):
		var angle = deg2rad(float(x))
		
		var vertex = Vector2(sin(angle), cos(angle)) * radius
		
		output.push_back(vertex)
	
	return output
