extends Control



func _on_replay_button_pressed():
	replay()


func _on_menu_button_pressed():
	main_menu()


func replay():
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")

func main_menu():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


var selections = ["Replay", "Main Menu"]

var i = 0


func _on_replay_button_mouse_entered():
	i = 0
	get_node("Arrow").position.y = get_node(str(selections[i], " Button")).position.y


func _on_main_menu_button_mouse_entered():
	i = 1
	get_node("Arrow").position.y = get_node(str(selections[i], " Button")).position.y

