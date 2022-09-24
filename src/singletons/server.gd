extends Node

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
		tree.connect("network_peer_connected", self, "")
		tree.connect("network_peer_disconnected", self, "")
		
		peer.create_server(params.port)
	else:
		tree.connect("connected_to_server", self, "")
		tree.connect("connection_failed", self, "")
	
	tree.network_peer = peer

func _ready():
	init(true, Parameters.new())
