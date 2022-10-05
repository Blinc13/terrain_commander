extends Control

class_name MainMenuRoot

class Changes:
	var ui_el_f: Control
	var ui_el_s: Control
	
	func _init(ui_el_f: Control, ui_el_s: Control):
		self.ui_el_f = ui_el_f
		self.ui_el_s = ui_el_s

const TRANSITION_TIME = 1.6

onready var levels = $LevelsList
onready var lobby = $Lobby
onready var tween = $Tween

var changes_list = Array()

func change_places(changes: Changes):
	changes_list.push_back(changes)
	
	tween.change_places(changes.ui_el_f, changes.ui_el_s, TRANSITION_TIME)
	tween.start()

func undo_change_places():
	var changes = changes_list.pop_back()
	
	tween.change_places(changes.ui_el_s, changes.ui_el_f, TRANSITION_TIME)
	tween.start()


func level_selected(path):
	print_debug(path)
