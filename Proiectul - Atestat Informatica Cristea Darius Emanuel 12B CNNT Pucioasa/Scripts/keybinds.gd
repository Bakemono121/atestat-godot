extends Node2D


func to_menu():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _unhandled_input(event):
	if Input.is_action_just_pressed("escape") or Input.is_action_just_pressed("shoot"):
		to_menu()


func _on_button_pressed():
	to_menu()
