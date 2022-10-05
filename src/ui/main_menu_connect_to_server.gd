extends VBoxContainer

onready var ip_edit = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/IpEdit
onready var port_edit = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/PortEdit

# Funcs
func connect_to_server():
	var ip = ip_edit.text
	var port = int(port_edit.text)
	
	if port == 0: # If port is incorrect, set to default
		port = 8080
	
	var server_params = Server.Parameters.new(ip, port)
	
	Server.init(false, server_params)
