extends Node2D


func _ready():
	if FileAccess.file_exists("user://savegame.save") == false:
		save_game()
	
	load_game()
	
	if save_dict["fullscreen"] == "true":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN, 0)
	
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -35 + 0.3 * int(save_dict["master_volume"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -25 + 0.3 * int(save_dict["music_volume"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), -35 + 0.3 * int(save_dict["effects_volume"]))




var high_score = 0
var controller_vibration = true
var fullscreen = false
var master_volume = 100
var music_volume = 100
var effects_volume = 100

var save_dict = {
	"high_score" : high_score,
	
	"controller_vibration" : controller_vibration,
	"fullscreen": fullscreen,
	
	"master_volume" : master_volume,
	"music_volume" : music_volume,
	"effects_volume" : effects_volume,
}

func load_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	for i in save_dict.keys():
		save_dict[i] = save_game.get_line()
	



func save_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	for i in save_dict.keys():
		save_game.store_line(str(save_dict[i]))
	
