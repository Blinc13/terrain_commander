extends StaticBody2D

class_name TerrainFragment


class FragmentParameters:
	var texture: Texture
	var material: Material
	
	func _init(tex: Texture, mat: Material):
		texture = tex
		material = mat

var pol: Polygon2D
var col: CollisionPolygon2D

func _init(polygon: PoolVector2Array, params: FragmentParameters):
	pol = Polygon2D.new()
	col = CollisionPolygon2D.new()
	
	pol.set_deferred("polygon", polygon)
	col.set_deferred("polygon", polygon)
	
	pol.texture = params.texture
	pol.material = params.material
	
	add_child(pol)
	add_child(col)

func clip_polygon(polygon: PoolVector2Array):
	var poly = Geometry.clip_polygons_2d(pol.polygon, polygon)
	
	pol.set_deferred("polygon", poly[0])
	col.set_deferred("polygon", poly[0])
	
	if poly.size() >= 2:
		poly.remove(0)
		
		return poly

func set_texture(texture: Texture):
	pol.texture = texture

func set_material(m: Material):
	pol.material = m

func set_parameters(params: FragmentParameters):
	pol.texture = params.texture
	pol.material = params.material

func get_parameters():
	return FragmentParameters.new(pol.texture, pol.material)
