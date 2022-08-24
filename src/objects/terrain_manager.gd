extends Node2D

class_name TerrainManager

func cut_of(polygon: PoolVector2Array, part: Object, pos: Vector2):
	var mesh = PoolVector2Array()
	
	for x in polygon:
		mesh.push_back(x + pos)
	
	var fragmet = part as TerrainFragment
	var array = fragmet.clip_polygon(mesh)
	
	if array != null:
		var new_fragment = TerrainFragment.new(array[0], fragmet.get_parameters())
		
		add_child(new_fragment)


# Only for editor
func _ready():
	for x in get_child_count():
		var child = get_child(x)
		
		if child is Polygon2D:
			var params = TerrainFragment.FragmentParameters.new(child.texture, child.material)
			var new_child = TerrainFragment.new(child.polygon, params)
			
			add_child(new_child)
			child.queue_free()
