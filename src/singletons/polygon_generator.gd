extends Node


static func generate_circle(radius: float) -> PoolVector2Array:
	var output = PoolVector2Array()
	
	for x in range(0, 380, 24):
		var angle = deg2rad(float(x))
		
		var vertex = Vector2(cos(angle), sin(angle)) * radius
		
		output.push_back(vertex)
	
	return output
