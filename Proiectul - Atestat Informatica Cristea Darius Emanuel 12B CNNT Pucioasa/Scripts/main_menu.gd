extends Node2D



var selections = ["Start", "Settings", "Keybinds" ,"Exit"]

var i = 0

func _ready():
	get_parent().get_tree().paused = false
	
	$"High Score".text = str("High Score: ", Save.save_dict["high_score"] )


func _unhandled_input(event):
	
	if Input.is_action_just_pressed("escape"):
		switch_settings()
	
	if get_node("Settings").visible:
		return
	
	
	
	elif Input.is_action_just_pressed("up"):
		i -= 1
	elif Input.is_action_just_pressed("down"):
		i += 1
	
	if i+1 > len(selections):
		i = 0
	elif i < 0:
		i = len(selections) - 1
	
	get_node("Menu/Arrow").position.y = get_node(str("Menu/", selections[i])).position.y
	
	if Input.is_action_just_pressed("shoot"):
		if i == 0:
			start()
		elif i == 1:
			switch_settings()
		elif i == 2:
			keybinds()
		elif i == 3:
			exit()


func exit():
	get_tree().quit()

func start():
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")

func keybinds():
	get_tree().change_scene_to_file("res://Scenes/keybinds.tscn")


func _on_exit_pressed():
	exit()

func _on_start_pressed():
	start()


func _on_options_pressed():
	switch_settings()



func switch_settings():
	Save.save_game()
	$Menu/Arrow.visible = not $Menu/Arrow.visible
	$Menu.get_tree().paused = not $Menu.get_tree().paused
	get_node("Settings").visible = not get_node("Settings").visible
	
	get_node("Settings/Sprite2D").self_modulate.a = 255




func _on_start_mouse_entered():
	i = 0
	get_node("Menu/Arrow").position.y = get_node(str("Menu/", selections[i])).position.y


func _on_settings_mouse_entered():
	i = 1
	get_node("Menu/Arrow").position.y = get_node(str("Menu/", selections[i])).position.y


func _on_exit_mouse_entered():
	i = 3
	get_node("Menu/Arrow").position.y = get_node(str("Menu/", selections[i])).position.y


func _on_keybinds_mouse_entered():
	i = 2
	get_node("Menu/Arrow").position.y = get_node(str("Menu/", selections[i])).position.y

func _on_keybinds_pressed():
	keybinds()


func _on_settings_visibility_changed():
	if $Settings.visible == true:
		return
	$Menu/Arrow.visible = true
	$Menu.get_tree().paused = true
