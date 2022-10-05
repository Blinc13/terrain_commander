extends VBoxContainer

signal LevelSelected(path)

onready var embeded = $HBoxContainer/VBoxContainer/LevelsList/TabContainer/Embeded
onready var custom = $HBoxContainer/VBoxContainer/LevelsList/TabContainer/Custom

var embeded_levels_path_list = PoolStringArray()
var custom_levels_path_list = PoolStringArray()

func _ready():
	add_embeded_level("TestLevel", "res://levels/TestLevel.tscn")

# Funcs
func add_embeded_level(name: String, path: String):
	embeded.add_item(name)
	embeded_levels_path_list.push_back(path)

func add_custom_level(name: String, path: String):
	custom.add_item(name)
	custom_levels_path_list.push_back(path)


# Slots
func embeded_level_selected(index):
	emit_signal("LevelSelected", embeded_levels_path_list[index])

func custom_level_selected(index):
	emit_signal("LevelSelected", custom_levels_path_list[index])
