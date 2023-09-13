extends CanvasLayer


@onready var info = $Info
@onready var menu = $Menu
@onready var settings = $Settings
@onready var death_menu = $"Death Menu"

func _unhandled_input(event):
	if Input.is_action_just_pressed("escape") and $"../Upgrades".visible == false:
		if settings.visible:
			settings.visible = not settings.visible
			menu.visible = not menu.visible
			return
		
		if death_menu.visible == false:
			#get_tree().paused = not get_tree().paused
			menu.visible = not menu.visible
			get_node("Menu").i = 0
			
			if get_tree().paused == false:
				get_tree().paused = true
			else:
				get_parent().pause_a_little()
	
	if get_node("Menu").visible:
		if Input.is_action_just_pressed("up"):
			menu.i -= 1
		elif Input.is_action_just_pressed("down"):
			menu.i += 1
		
		if menu.i+1 > len(menu.selections):
			menu.i = 0
		elif menu.i < 0:
			menu.i = len(menu.selections) - 1
		
		get_node("Menu/Arrow").position.y = get_node(str("Menu/", menu.selections[menu.i], " Button")).position.y
		
		if Input.is_action_just_pressed("shoot"):
			if menu.i == 0:
				menu.return_to_game()
			elif menu.i == 1:
				menu.switch_settings()
			elif menu.i == 2:
				menu.main_menu()
		
	elif get_node("Death Menu").visible:
		if Input.is_action_just_pressed("up"):
			death_menu.i -= 1
		elif Input.is_action_just_pressed("down"):
			death_menu.i += 1
		
		if death_menu.i+1 > len(death_menu.selections):
			death_menu.i = 0
		elif death_menu.i < 0:
			death_menu.i = len(death_menu.selections) - 1
		
		get_node("Death Menu/Arrow").position.y = get_node(str("Death Menu/", death_menu.selections[death_menu.i], " Button")).position.y
		
		if Input.is_action_just_released("shoot"):
			if death_menu.i == 0:
				death_menu.replay()
			elif death_menu.i == 1:
				death_menu.main_menu()
