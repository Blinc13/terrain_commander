extends Control

onready var levels_list = $LevelsList/HBoxContainer/LevelsList

func quit():
	get_tree().quit(0)

func host():
	init_levels_list()
	
	$Tween.change_places($MainScreen, $LevelsList, 1.6)
	$Tween.start()

#######################Levels list############################
onready var embeded_levels = $LevelsList/HBoxContainer/LevelsList/TabContainer/Embeded
#onready var custom_levels = $LevelsList/TabContainer/Custom
var selected_level_scene_path: String

func init_levels_list():
	add_embeded_level("Test level", "res://levels/TestLevel.tscn")


var embeded_levels_list = Array()
#var custom_levels_list = Array()

func add_embeded_level(name: String, path: String):
	embeded_levels.add_item(name)
	embeded_levels_list.push_back(path)

func embeded_level_selected(index):
	# This is prototype
	selected_level_scene_path = embeded_levels_list[index]
	init_lobby()
	

#######################Lobby#####################################
func init_lobby():
	$Tween.change_places($LevelsList, $Lobby, 1.6)
	$Tween.start()

func server_start():
	Server.init(true, Server.Parameters.new())
	$Lobby/VBoxContainer/StartGame.show()

func connect_to_server():
	Server.init(false, Server.Parameters.new("127.0.0.1"))

func start_game():
	Server.start_game(selected_level_scene_path)
	hide()
