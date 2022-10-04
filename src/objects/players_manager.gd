extends Node

class_name PlayersManager

export(PoolVector2Array) var spawn_points

var master_player = preload("res://scenes/units/Player/MasterPlayer.tscn")
var puppet_player = preload("res://scenes/units/Player/PuppetPlayer.tscn")

func _init():
	BaseNodes.players_manager = self
	
	Server.connect("ClientDisconnected", self, "client_disconnected")

# Server slot
func client_disconnected(id: int):
	if !has_node(str(id)): # Client already killed
		return
	
	remove_player(id)

# Remote funcs
remotesync func instance_player_local(id: int):
	var instanced: Node2D
	
	if id == get_tree().get_network_unique_id():
		instanced = master_player.instance()
	else:
		instanced = puppet_player.instance()
	
	instanced.set_network_master(id)
	instanced.name = str(id)
	
	instanced.position = spawn_points[ randi() % spawn_points.size() ]
	
	add_player(instanced)

remotesync func remove_player_local(id: int):
	var player = get_node(str(id))
	
	remove_child(player)
	player.queue_free()

func get_alive_players_list() -> Array:
	# TODO: Add exclude to not-player 
	var array = Array()
	
	for player in get_children():
		array.push_back(int(player.name)) # Because name of player = id, pushing int(str) into array
	
	return array

func add_player(player: Node):
	add_child(player)

func remove_player(id: int):
	rpc("remove_player_local", id)

# Comment: in output will be errors, because client already send some packets and dont received remove packet
