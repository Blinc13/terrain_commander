extends Node

signal ClientConnected(id)
signal ClientDisconnected(id)

signal ConnectionSucces(players)
signal ConnectionFail

class Parameters:
	var ip: String
	var port: int
	
	func _init(ip: String = "", port = 8080):
		self.ip = ip
		self.port = port


var peer: NetworkedMultiplayerPeer


func init(is_master: bool, params: Parameters):
	peer = NetworkedMultiplayerENet.new()
	var tree = get_tree()
	
	if is_master:
		tree.connect("network_peer_connected", self, "client_connected")
		tree.connect("network_peer_disconnected", self, "client_disconnected")
		
		peer.create_server(params.port)
	else:
		tree.connect("connected_to_server", self, "connected_to_server")
		tree.connect("connection_failed", self, "connection_failed")
		
		peer.create_client(params.ip, params.port)
	
	tree.network_peer = peer

# Server funcs
func client_connected(id):
	print("Connected: ", id)
	emit_signal("ClientConnected", id)

func client_disconnected(id):
	print("Disconnected: ", id)
	emit_signal("ClientDisconnected", id)


# Client funcs
func connected_to_server():
	emit_signal("ClientConnected", get_tree().get_network_connected_peers())

func connection_failed():
	emit_signal("ConnectionFail")

# General functions
master func start_game(level_scene_path: String):
	rpc("load_level", level_scene_path)
	
	init_players()

master func init_players():
	assert(BaseNodes.players_manager, "Game not started")
	
	# Instance scenes for every player
	for id in get_tree().get_network_connected_peers():
		BaseNodes.players_manager.rpc("instance_player", id)
	
	# And for server
	BaseNodes.players_manager.rpc("instance_player", 1)

remotesync func load_level(path: String):
	var level = load(path).instance()
	get_parent().add_child(level)
