extends Node

enum Nt {
	PlayersManager,
	TerrainManager,
	Player,
	Game
}


signal NodeAdded(node_type)


var players_manager: PlayersManager setget players_manager_set
var terrain_manager: TerrainManager setget terrain_manager_set
var player: Player setget player_set
var game: Game setget game_set


func players_manager_set(node: PlayersManager):
	players_manager = node
	
	emit_signal("NodeAdded", Nt.PlayersManager)

func terrain_manager_set(node: TerrainManager):
	terrain_manager = node
	
	emit_signal("NodeAdded", Nt.TerrainManager)

func player_set(node: Player):
	player = node
	
	emit_signal("NodeAdded", Nt.Player)

func game_set(node: Game):
	game = node
	
	emit_signal("NodeAdded", Nt.Game)
