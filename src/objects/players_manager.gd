extends Node

class_name PlayersManager

var master_player = preload("res://scenes/units/Player/MasterPlayer.tscn")
var puppet_player = preload("res://scenes/units/Player/PuppetPlayer.tscn")

remote func append_player(id: int):
	var instanced: Node
	
	if id == get_tree().get_network_unique_id():
		instanced = master_player.instance()
	else:
		instanced = puppet_player.instance()
	
	instanced.set_network_master(id)
	add_player(instanced)

func add_player(player: Node):
	add_child(player)

func _init():
	BaseNodes.players_manager = self
