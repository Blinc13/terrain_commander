extends Control

onready var levels_list = $LevelsList

func quit():
	get_tree().quit(0)

func play():
	init_levels_list()
	
	levels_list.show()



onready var embeded_levels = $LevelsList/TabContainer/Embeded
onready var custom_levels = $LevelsList/TabContainer/Custom

func init_levels_list():
	embeded_levels.add_item("Test scene")
