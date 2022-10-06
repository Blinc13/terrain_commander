extends VBoxContainer

onready var parrent = get_parent()

var level: String


func _init():
	Server.connect("ClientConnected", self, "handle_connection")
	
	Server.connect("GameStarted", self, "game_started")
	Server.connect("GameEnded", self, "game_ended")

# Slots
func set_level(path: String):
	level = path

func handle_connection(_id):
	start_game()

func close_server():
	Server.close()

func game_started():
	parrent.hide()
	parrent.undo_change_places()

func game_ended():
	parrent.show()
	
	close_server()
	
	get_node("/root/Game").queue_free()

# Funcs
func start_server():
	Server.init(true, Server.Parameters.new())

func start_game():
	Server.start_game(level)
