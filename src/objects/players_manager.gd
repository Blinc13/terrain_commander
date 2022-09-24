extends Node

class_name PlayersManager

var master_player = preload("res://scenes/units/Player/MasterPlayer.tscn")
var puppet_player = preload("res://scenes/units/Player/PuppetPlayer.tscn")

remotesync func instance_player(id: int):
	var instanced: Node
	
	if id == get_tree().get_network_unique_id():
		instanced = master_player.instance()
	else:
		instanced = puppet_player.instance()
	
	instanced.set_network_master(id)
	instanced.name = str(id)
	add_player(instanced)

remotesync func remove_player(id: int):
	get_node(str(id)).queue_free()

func add_player(player: Node):
	add_child(player)

# Slots
master func remove_player_slot(id: int):
	rpc("remove_player", id)

func _init():
	BaseNodes.players_manager = self
	
	Server.connect("ClientDisconnected", self, "remove_player_slot")
