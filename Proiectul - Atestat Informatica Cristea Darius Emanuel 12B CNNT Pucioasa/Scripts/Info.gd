extends Control



@onready var player = $"../../Player"


func _process(delta):
	get_node("Ammo").text = str(player.ammo)
	get_node("Health").text = str(player.health)
	get_node("Score").text = str(player.score)
