extends Control

export(float) var TURN_LABEL_DURATION = 4.0

onready var game = BaseNodes.game
var player: Player

onready var time_label = $VBoxContainer/Timer
onready var turn_label = $TurnMessage
onready var flip_label = $FlipLabel

func _ready():
	BaseNodes.connect("NodeAdded", self, "node_added")
	
	game.connect("FireTurn", self, "turn_event", ["Fire turn!"])
	game.connect("MoveTurn", self, "turn_event", ["Move turn!"])
	game.connect("GameEnded", self, "winner")

func _process(delta):
	var time = game.get_duration_of_current_turn()
	
	time_label.text = time_to_string(time - game.time)

func node_added(node_type):
	if node_type == BaseNodes.Nt.Player:
		player = BaseNodes.player
		
		player.connect("Overturned", self, "flip")

func handle_timer():
	turn_label.hide()

func turn_event(text: String):
	turn_label.text = text
	turn_label.show()
	
	get_tree().create_timer(TURN_LABEL_DURATION).connect("timeout", self, "handle_timer")

func time_to_string(time: float) -> String:
	var seconds = int(time)
	var minuts = seconds / 60
	
	return str(minuts) + ' ' + str(seconds)

func flip():
	if player.is_flipped:
		flip_label.show()
	else:
		flip_label.hide()

func winner(winner):
	$VBoxContainer.hide()
	
	turn_label.show()
	turn_label.text = "Winner is " + str(winner)
	
	game.disconnect("MoveTurn", self, "turn_event")
	game.disconnect("FireTurn", self, "turn_event")
