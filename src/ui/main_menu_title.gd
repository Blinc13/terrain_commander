extends VBoxContainer

onready var parrent = get_parent()

# Slots
func host_game():
	var changes = MainMenuRoot.Changes.new(self, parrent.levels)
	
	parrent.change_places(changes)


func connect_to_game():
	var changes = MainMenuRoot.Changes.new(self, parrent.connection_menu)
	
	parrent.change_places(changes)


func close_game():
	get_tree().quit(0)
