extends TextureRect

var move_turn_icon: Texture = preload("res://assets/textures/ui/icons/move_turn_icon.png")
var fire_turn_icon: Texture = preload("res://assets/textures/ui/icons/fire_turn_icon.png")

func _init():
	stretch_mode = STRETCH_KEEP_ASPECT_CENTERED

func _ready():
	BaseNodes.game.connect("MoveTurn", self, "set_move_turn_icon")
	BaseNodes.game.connect("FireTurn", self, "set_fire_turn_icon")


func set_move_turn_icon():
	texture = move_turn_icon

func set_fire_turn_icon():
	texture = fire_turn_icon
