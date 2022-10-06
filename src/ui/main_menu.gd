extends Control

class_name MainMenuRoot

class Changes:
	var ui_el_f: Control
	var ui_el_s: Control
	
	func _init(ui_el_f: Control, ui_el_s: Control):
		self.ui_el_f = ui_el_f
		self.ui_el_s = ui_el_s

const TRANSITION_TIME = 1.6

onready var connection_menu = $Connect
onready var levels = $LevelsList
onready var lobby = $Lobby
onready var tween = $Tween

var changes_list = Array()
var change_complite: bool = true

# Funcs
func change_places(change: Changes):
	changes_list.push_back(change)
	
	if change_complite:
		change_complite = false
		
		tween.change_places(change.ui_el_f, change.ui_el_s, TRANSITION_TIME)
		tween.start()

func undo_change_places():
	if changes_list.size() < 1:
		return
	
	if change_complite:
		change_complite = false
		
		var change = changes_list.pop_back()
		
		tween.change_places(change.ui_el_s, change.ui_el_f, TRANSITION_TIME)
		tween.start()


# Slots
func level_selected(path):
	change_places(Changes.new(levels, lobby))
	
	lobby.start_server()

func change_completed():
	change_complite = true
