extends Node2D

class_name Game

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
		rpc("rpc_signal_with_arg", "CanFire", true)
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


# This method informs server about the this client player destroyed
func player_destoryed():
	rpc_id(1, "player_destroyed_rpc")

master func player_destroyed_rpc():
	var p_manager = BaseNodes.players_manager
	
	p_manager.remove_player(get_tree().get_rpc_sender_id()) # Removing player with sender id on all clients
	var players = p_manager.get_alive_players_list()
	
	if players.size() == 1:
		rpc("receive_winner", players[0]) # Sending clients info about winner

remotesync func receive_winner(id: int):
	print_debug("Winner is: ", id) # For now, something like this
