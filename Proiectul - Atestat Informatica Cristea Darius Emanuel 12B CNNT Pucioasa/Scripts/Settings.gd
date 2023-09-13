extends Control


var controller_vibration = true


func _ready():

	if Save.save_dict["controller_vibration"] == "true":
		get_node("Sections/Game/Controller Vibration Check").button_pressed = true
	
	if Save.save_dict["fullscreen"] == "true":
		get_node("Sections/Game/Fullscreen Checkbox").button_pressed = true
	
	get_node("Sections/Audio/Master Volume Value").value = int(Save.save_dict["master_volume"])
	get_node("Sections/Audio/Master Sound Slider").value = int(Save.save_dict["master_volume"])
	get_node("Sections/Audio/Music Volume Value").value= int(Save.save_dict["music_volume"])
	get_node("Sections/Audio/Music Sound Slider").value = int(Save.save_dict["music_volume"])
	get_node("Sections/Audio/Effects Volume Value").value = int(Save.save_dict["effects_volume"])
	get_node("Sections/Audio/Effects Sound Slider").value = int(Save.save_dict["effects_volume"])
	


func _on_visibility_changed():
	$Arrow.position = positions["buttons"][0]
	see_game()
	selected = $Buttons/Game

var positions = {
	"buttons": [ Vector2(112,8), Vector2(296,8), Vector2(480,8)],
	"things" : [Vector2(488, 72), Vector2(488, 136), Vector2(488, 200)]
	}

var selected
func _unhandled_input(event):
	if not visible:
		return
	
	if $Sections/Game.visible:
		if Input.is_action_just_pressed("right"):
			if $Arrow.position == positions["buttons"][0]:
				
				selected = $Buttons/Audio
				$Arrow.position = positions["buttons"][1]
			elif $Arrow.position == positions["buttons"][1]:
				
				selected = $Buttons/Back
				$Arrow.position = positions["buttons"][2]
				
		elif Input.is_action_just_pressed("left"):
			if $Arrow.position == positions["buttons"][1]:
				
				$Arrow.position = positions["buttons"][0]
			elif $Arrow.position == positions["buttons"][2]:
				
				selected = $Buttons/Audio
				$Arrow.position = positions["buttons"][1]
		
		elif Input.is_action_just_pressed("down"):
			if $Arrow.position == positions["buttons"][0] or $Arrow.position == positions["buttons"][1] or $Arrow.position == positions["buttons"][2]:
				
				$Arrow.position = positions["things"][0]
				
				selected = $"Sections/Game/Fullscreen Checkbox"
				
			elif $Arrow.position == positions["things"][0]:
				
				$Arrow.position = positions["things"][1]
				
				selected = $"Sections/Game/Controller Vibration Check"
		
		elif Input.is_action_just_pressed("up"):
			if $Arrow.position == positions["things"][1]:
				
				selected = $"Sections/Game/Fullscreen Checkbox"
				$Arrow.position = positions["things"][0]
				
			elif $Arrow.position == positions["things"][0]:
				
				selected = $Buttons/Game
				$Arrow.position = positions["buttons"][0]
	
	elif $Sections/Audio.visible:
		if Input.is_action_just_pressed("right"):
			if $Arrow.position == positions["buttons"][0]:
				
				selected = $Buttons/Audio
				$Arrow.position = positions["buttons"][1]
			elif $Arrow.position == positions["buttons"][1]:
				
				selected = $Buttons/Back
				$Arrow.position = positions["buttons"][2]
			
		elif Input.is_action_just_pressed("left"):
			if $Arrow.position == positions["buttons"][1]:
				
				selected = $Buttons/Game
				$Arrow.position = positions["buttons"][0]
				
			elif $Arrow.position == positions["buttons"][2]:
				
				selected = $Buttons/Audio
				$Arrow.position = positions["buttons"][1]
		
		elif Input.is_action_just_pressed("down"):
			if $Arrow.position == positions["buttons"][0] or $Arrow.position == positions["buttons"][1] or $Arrow.position == positions["buttons"][2]:
				
				selected = $"Sections/Audio/Master Volume Value"
				$Arrow.position = positions["things"][0]
			elif $Arrow.position == positions["things"][0]:
				
				selected = $"Sections/Audio/Music Volume Value"
				$Arrow.position = positions["things"][1]
				
			elif $Arrow.position == positions["things"][1]:
				
				selected = $"Sections/Audio/Effects Volume Value"
				$Arrow.position = positions["things"][2]
		
		elif Input.is_action_just_pressed("up"):
			if $Arrow.position == positions["things"][2]:
				
				selected = $"Sections/Audio/Music Volume Value"
				$Arrow.position = positions["things"][1]
				
			elif $Arrow.position == positions["things"][1]:
				
				selected = $"Sections/Audio/Master Volume Value"
				$Arrow.position = positions["things"][0]
				
			elif $Arrow.position == positions["things"][0]:
				
				selected = $Buttons/Audio
				$Arrow.position = positions["buttons"][1]
	
	if Input.is_action_pressed("right") and (selected == $"Sections/Audio/Master Volume Value" or selected == $"Sections/Audio/Music Volume Value" or selected == $"Sections/Audio/Effects Volume Value"):
		selected.value += 1
	elif Input.is_action_pressed("left") and (selected == $"Sections/Audio/Master Volume Value" or selected == $"Sections/Audio/Music Volume Value" or selected == $"Sections/Audio/Effects Volume Value"):
		selected.value -= 1
	
	if Input.is_action_just_released("shoot"):
		do_the_thing()


func do_the_thing():
	if selected == $Buttons/Game:
		see_game()
	elif selected == $Buttons/Audio:
		see_audio()
	elif selected == $Buttons/Back:
		go_back()
	elif selected == $"Sections/Game/Fullscreen Checkbox":
		selected.button_pressed = not selected.button_pressed
		fullscreen_checkbox()
	elif selected == $"Sections/Game/Controller Vibration Check":
		selected.button_pressed = not selected.button_pressed
		switch_controller_vibration()

func see_audio():
	for section in get_node("Sections").get_children():
		section.visible = false
	get_node("Sections/Audio").visible = true
	$Arrow.position = positions["buttons"][1]


func _on_audio_pressed():
	see_audio()




func _on_master_sound_slider_value_changed(value):
	Save.save_dict["master_volume"] = str(get_node("Sections/Audio/Master Sound Slider").value)
	Save.save_game()
	get_node("Sections/Audio/Master Volume Value").value = int(Save.save_dict["master_volume"])
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -35 + 0.3 * value)
	if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) <= -35:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)

func _on_music_sound_slider_value_changed(value):
	
	Save.save_dict["music_volume"] = str(get_node("Sections/Audio/Music Sound Slider").value)
	Save.save_game()
	get_node("Sections/Audio/Music Volume Value").value = int(Save.save_dict["music_volume"])
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -25 + 0.3 * value)
	
	if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")) <= -25:
	
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)

func _on_effects_sound_slider_value_changed(value):
	Save.save_dict["effects_volume"] = str(get_node("Sections/Audio/Effects Sound Slider").value)
	Save.save_game()
	get_node("Sections/Audio/Effects Volume Value").value = int(Save.save_dict["effects_volume"])
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), -35 + 0.3 * value)
	if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Effects")) <= 34:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Effects"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Effects"), false)


func _on_master_volume_value_value_changed(value):
	get_node("Sections/Audio/Master Sound Slider").value = value
	Save.save_dict["master_volume"] = str(get_node("Sections/Audio/Master Sound Slider").value)
	Save.save_game()
	get_node("Sections/Audio/Master Volume Value").value = int(Save.save_dict["master_volume"])

func _on_music_volume_value_value_changed(value):
	get_node("Sections/Audio/Music Sound Slider").value = value
	Save.save_dict["music_volume"] = str(get_node("Sections/Audio/Music Sound Slider").value)
	Save.save_game()
	get_node("Sections/Audio/Music Volume Value").value = int(Save.save_dict["music_volume"])


func _on_effects_volume_value_value_changed(value):
	get_node("Sections/Audio/Effects Sound Slider").value = value
	Save.save_dict["effects_volume"] = str(get_node("Sections/Audio/Master Sound Slider").value)
	Save.save_game()
	get_node("Sections/Audio/Master Volume Value").value = int(Save.save_dict["master_volume"])


func go_back():
	Save.save_game()
	visible = false
	get_parent().get_node("Menu").visible = true


func _on_back_pressed():
	go_back()


func see_game():
	for section in get_node("Sections").get_children():
		section.visible = false
	
	get_node("Sections/Game").visible = true
	
	$Arrow.position = positions["buttons"][0]

func _on_game_pressed():
	see_game()


func _on_fullscreen_checkbox_pressed():
	fullscreen_checkbox()


func _on_controller_vibration_check_pressed():
	switch_controller_vibration()


func switch_controller_vibration():
	controller_vibration = get_node("Sections/Game/Controller Vibration Check").button_pressed #MAKE IT SAVE
	Save.save_dict["controller_vibration"] = str(controller_vibration)
	
	Save.save_game()

func fullscreen_checkbox():
	if get_node("Sections/Game/Fullscreen Checkbox").button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN, 0)
		Save.save_dict["fullscreen"] = str(true)
		
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, 0)
		Save.save_dict["fullscreen"] = str(false)
	Save.save_game()
