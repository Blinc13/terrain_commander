extends Node2D

class_name TerrainManager

func cut_of(polygon: PoolVector2Array, pos: Vector2):
	rpc("cut_of_local", polygon, pos)

func clip_polygon_for_fragment(fragment: TerrainFragment, polygon):
	var array = fragment.clip_polygon(polygon)
	
	if array != null:
		for polygon in array:
			create_fragment(polygon, fragment.get_parameters())

func create_fragment(polygon: PoolVector2Array, params: TerrainFragment.Parameters):
	var new_fragment = TerrainFragment.new(polygon, params)
	
	add_child(new_fragment)


func create_shape(polygon: PoolVector2Array) -> ConvexPolygonShape2D:
	var shape = ConvexPolygonShape2D.new()
	
	shape.points = polygon
	
	return shape

remotesync func cut_of_local(polygon: PoolVector2Array, pos: Vector2):
	polygon = PolygonGenerator.move_polygon(polygon, pos)
	
	var affected_fragments = Misc.get_phys_objects_in_shape(create_shape(polygon), get_world_2d(), 9)
	
	for entry in affected_fragments:
		var fragment = entry["collider"] as TerrainFragment
		
		clip_polygon_for_fragment(fragment, polygon)


# Only for editor
func _ready():
	for x in get_child_count():
		var child = get_child(x)
		
		if child is Polygon2D:
			var params = TerrainFragment.Parameters.new(child.texture, child.material)
			
			create_fragment(child.polygon, params)
			
			child.queue_free()

func _init():
	BaseNodes.terrain_manager = self
