extends Node2D

class_name Game

signal GameStart
signal MoveTurn
signal FireTurn
signal CanFire(boolean)

# Duration of turns in seconds
var move_time: float = 15
var fire_time: float = 10

var time: float = 0
var is_move_turn: bool = false # In ready will be called change_turn(for less code)

func _physics_process(delta):
	time += delta
	
	if time >= get_duration_of_current_turn():
		change_turn()

func get_duration_of_current_turn() -> float:
	if is_move_turn:
		return move_time
	else:
		return fire_time

func change_turn():
	if is_move_turn:
		is_move_turn = false
		emit_signal("FireTurn")
		emit_signal("CanFire", true) # So far so, then it will be redone for multiplayer
	else:
		is_move_turn = true
		emit_signal("MoveTurn")
		emit_signal("CanFire", false)
	
	time = 0

# Debug
func move_handler():
	print_debug("move turn")

func fire_handler():
	print_debug("fire turn")


func _init():
	connect("FireTurn", self, "fire_handler")
	connect("MoveTurn", self, "move_handler")
	
	BaseNodes.game = self

func _ready():
	change_turn()
