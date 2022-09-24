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
		tree.connect("network_peer_connected", self, "client_connected")
		tree.connect("network_peer_disconnected", self, "client_disconnected")
		
		peer.create_server(params.port)
	else:
		tree.connect("connected_to_server", self, "connected_to_server")
		tree.connect("connection_failed", self, "connection_failed")
	
	tree.network_peer = peer

# Server funcs
func client_connected(id):
	print("Connected: ", id)

func client_disconnected(id):
	print("Disconnected: ", id)


# Client funcs
func connected_to_server():
	pass

func connection_failed():
	pass

# General functions
