extends Node

class_name PlayersManager

export(PoolVector2Array) var spawn_points

var master_player = preload("res://scenes/units/Player/MasterPlayer.tscn")
var puppet_player = preload("res://scenes/units/Player/PuppetPlayer.tscn")

func _init():
	BaseNodes.players_manager = self
	
	Server.connect("ClientDisconnected", self, "remove_player_slot")

# Slots
master func remove_player_slot(id: int):
	rpc("remove_player_local", id)

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
	get_node(str(id)).queue_free()

func add_player(player: Node):
	add_child(player)
