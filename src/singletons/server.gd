extends Node

signal ClientConnected(id)
signal ClientDisconnected(id)

signal ConnectionSucces
signal ConnectionFail

signal GameStarted
signal GameEnded

class Parameters:
	var ip: String
	var port: int
	var max_clients: int
	
	func _init(ip: String = "", port: int = 8080, max_clients: int = 2):
		self.ip = ip
		self.port = port
		self.max_clients = max_clients


var peer: NetworkedMultiplayerPeer


func init(is_master: bool, params: Parameters):
	peer = NetworkedMultiplayerENet.new()
	var tree = get_tree()
	
	if is_master:
		tree.connect("network_peer_connected", self, "client_connected")
		tree.connect("network_peer_disconnected", self, "client_disconnected")
		
		peer.create_server(params.port, params.max_clients)
	else:
		tree.connect("connected_to_server", self, "connected_to_server")
		tree.connect("connection_failed", self, "connection_failed")
		tree.connect("server_disconnected", self, "server_disconnected") # This code dont work, i dont kwon how to handle connection reset from server
		
		peer.create_client(params.ip, params.port)
	
	tree.network_peer = peer

# Server slots
func client_connected(id):
	emit_signal("ClientConnected", id)

func client_disconnected(id):
	emit_signal("ClientDisconnected", id)


# Client slots
func connected_to_server():
	emit_signal("ConnectionSucces")

func connection_failed():
	emit_signal("ConnectionFail")

func servet_disconnected():
	get_tree().quit(1) # Temporary solution

func game_ended():
	emit_signal("GameEnded")
	close()

# General functions
func close():
	get_tree().network_peer = null

master func start_game(level_scene_path: String):
	rpc("load_level_local", level_scene_path)
	
	init_players()
	
	rpc("emit_game_started")

master func init_players():
	assert(BaseNodes.players_manager, "Game not started")
	
	var players_id_list = get_tree().get_network_connected_peers()
	players_id_list.push_back(1) # Add server id
	
	# Instance scenes for every player
	for id in players_id_list:
		BaseNodes.players_manager.rpc("instance_player_local", id)

remotesync func emit_game_started():
	emit_signal("GameStarted")

remotesync func load_level_local(path: String):
	var level = load(path).instance()
	get_parent().add_child(level)
	
	BaseNodes.game.connect("tree_exiting", self, "game_ended")
