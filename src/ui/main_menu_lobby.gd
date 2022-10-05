extends VBoxContainer

# TODO: Remake lobby and this script

var level: String

func set_level(path: String):
	level = path


func start_server():
	Server.init(true, Server.Parameters.new())
	
	$HBoxContainer/Lobby/VBoxContainer/StartGame.show()

func connect_to_server():
	Server.init(false, Server.Parameters.new("127.0.0.1"))

# Here should call hide but I'm too lazy
func start_game():
	Server.start_game(level)
