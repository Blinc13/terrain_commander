extends Node2D

class_name Game

signal GameStart
signal MoveTurn
signal FireTurn
signal CanFire(boolean)

# Duration of turns in seconds
var move_time: float = 15
var fire_time: float = 10

remotesync var time: float = 0
remotesync var is_move_turn: bool = false # In ready will be called change_turn(for less code)

func _physics_process(delta):
	time += delta
	
	if !is_network_master():
		return
	
	if time >= get_duration_of_current_turn():
		change_turn()

func get_duration_of_current_turn() -> float:
	if is_move_turn:
		return move_time
	else:
		return fire_time

func change_turn():
	if is_move_turn:
		rset("is_move_turn", false)
		
		rpc("rpc_signal", "FireTurn")
		rpc("rpc_signal_with_arg", "CanFire", true) # So far so, then it will be redone for multiplayer
	else:
		rset("is_move_turn", true)
		
		rpc("rpc_signal", "MoveTurn")
		rpc("rpc_signal_with_arg", "CanFire", false)
	
	rset("time", 0) # Update time on clients

remotesync func rpc_signal(name: String):
	emit_signal(name)

remotesync func rpc_signal_with_arg(name: String, arg):
	emit_signal(name, arg)

# Debug
func move_handler():
	print_debug("move turn")

func fire_handler():
	print_debug("fire turn")


func _init():
	connect("FireTurn", self, "fire_handler")
	connect("MoveTurn", self, "move_handler")
	
	BaseNodes.game = self
	
	set_network_master(1)


# Time init neded for correct return value of get_duration_of_current_turn
func init_time(move_time: float, fire_time: float):
	if !is_network_master():
		return
	
	rpc("set_time_on_rpc", move_time, fire_time)

# Init time on rpc
remotesync func set_time_on_rpc(mt: float, ft: float):
	move_time = mt
	fire_time = ft


func _ready():
	if !is_network_master():
		return
	
	change_turn()
