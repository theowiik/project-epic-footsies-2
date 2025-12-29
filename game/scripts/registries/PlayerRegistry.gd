class_name PlayerRegistry
extends RefCounted


func get_all_players() -> Array[Player]:
	var players: Array[Player] = []
	for node in get_tree().get_nodes_in_group(Constants.PLAYERS_GROUP):
		players.append(node)
	return players
