extends VBoxContainer

var level: String


func _init():
	Server.connect("ClientConnected", self, "handle_connection")

# Slots
func set_level(path: String):
	level = path

func handle_connection(_id):
	start_game()

func close_server():
	Server.close()

# Funcs
func start_server():
	Server.init(true, Server.Parameters.new())

func start_game():
	Server.start_game(level)
	
	get_parent().hide() # Need to be rewritten because ui hides only on server
