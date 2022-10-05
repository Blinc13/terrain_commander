extends VBoxContainer

var level: String

func set_level(path: String):
	level = path


func start_server():
	Server.init(true, Server.Parameters.new())
	
	$HBoxContainer/Lobby/VBoxContainer/StartGame.show()

func connect_to_server():
	Server.init(false, Server.Parameters.new("127.0.0.1"))


func start_game():
	Server.start_game(level)
