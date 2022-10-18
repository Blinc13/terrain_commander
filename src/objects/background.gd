extends ParallaxBackground

class_name BackGround

var camera: Camera2D

func _init():
	set_process(false)

func _ready():
	BaseNodes.connect("NodeAdded", self, "node_added")


func _process(delta):
	scroll_offset = camera.global_position



func node_added(node):
	if node == BaseNodes.Nt.Player:
		camera = BaseNodes.player.get_node("Camera2D")
		
		set_process(true)
