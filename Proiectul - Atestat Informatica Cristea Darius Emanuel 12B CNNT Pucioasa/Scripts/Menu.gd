extends Control



func _on_main_menu_button_pressed():
	main_menu()


func _on_settings_button_pressed():
	switch_settings()


func _on_return_button_pressed():
	return_to_game()


func main_menu():
	get_parent().get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	visible = false

func return_to_game():
	get_parent().get_tree().paused = not get_parent().get_tree().paused
	visible = not visible
	get_parent().get_parent().pause_a_little()
	

func switch_settings():
	get_parent().get_node("Settings").visible = true
	visible = not visible



var selections = ["Return", "Settings" ,"Main Menu"]

var i = 0


func _on_return_button_mouse_entered():
	i = 0
	get_node("Arrow").position.y = get_node(str(selections[i], " Button")).position.y


func _on_settings_button_mouse_entered():
	i = 1
	get_node("Arrow").position.y = get_node(str(selections[i], " Button")).position.y


func _on_main_menu_button_mouse_entered():
	i = 2
	get_node("Arrow").position.y = get_node(str(selections[i], " Button")).position.y



