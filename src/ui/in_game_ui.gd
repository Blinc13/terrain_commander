extends Control

onready var game = BaseNodes.game

onready var time_label = $VBoxContainer/Timer
onready var turn_label = $TurnMessage
onready var hide_timer = $HideTimer

func _ready():
	game.connect("FireTurn", self, "turn_event", ["Fire turn!"])
	game.connect("MoveTurn", self, "turn_event", ["Move turn!"])

func _process(delta):
	var time = game.get_duration_of_current_turn()
	
	time_label.text = time_to_string(time - game.time)

func handle_timer():
	turn_label.hide()

func turn_event(text: String):
	turn_label.text = text
	turn_label.show()
	
	hide_timer.start(1)

func time_to_string(time: float) -> String:
	var seconds = int(time)
	var minuts = seconds / 60
	
	return str(minuts) + ' ' + str(seconds)
