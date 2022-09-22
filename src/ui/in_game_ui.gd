extends Control

onready var game = BaseNodes.game

onready var time_label = $VBoxContainer/Timer
onready var turn_label = $TurnMessage
onready var hide_timer = $HideTimer

func _ready():
	game.connect("FireTurn", self, "fire_turn")
	game.connect("MoveTurn", self, "move_turn")

func _process(delta):
	var time = game.get_duration_of_current_turn()
	
	time_label.text = time_to_string(time - game.time)

func move_turn():
	turn_label.text = "Move turn!"
	turn_label.show()

func fire_turn():
	turn_label.text = "Fire turn!"
	turn_label.show()

func handle_timer():
	turn_label.hide()

func set_turn_label_text(text: String):
	turn_label.text = text
	turn_label.show()
	
	hide_timer.start(1)

func time_to_string(time: float) -> String:
	var seconds = int(time)
	var minuts = seconds / 60
	
	return str(minuts) + ' ' + str(seconds)
