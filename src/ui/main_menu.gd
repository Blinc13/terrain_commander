extends Control

onready var levels_list = $LevelsList

func quit():
	get_tree().quit(0)

func play():
	init_levels_list()
	
	levels_list.show()



onready var embeded_levels = $LevelsList/TabContainer/Embeded
#onready var custom_levels = $LevelsList/TabContainer/Custom

var embeded_levels_list = Array()
#var custom_levels_list = Array()

func add_embeded_level(name: String, path: String):
	embeded_levels.add_item(name)
	embeded_levels_list.push_back(path)

func init_levels_list():
	add_embeded_level("Test level", "res://levels/TestLevel.tscn")

func embeded_level_selected(index):
	var level_scene = load(embeded_levels_list[index]) as PackedScene
	var level = level_scene.instance()
	
	visible = false
	
	get_parent().add_child(level)
