extends Node2D


var rng = RandomNumberGenerator.new()


func _unhandled_input(event):
	if visible == false:
		return
	if Input.is_action_just_pressed("left"):
		select_option1()
	elif Input.is_action_just_pressed("right"):
		select_option2()
	elif Input.is_action_just_pressed("shoot"):
		select_option()

var selected
func select_option1():
	if $Option1.visible == false:
		return
	selected = option1
	$CanvasLayer/Arrow.position.x = $Option1.position.x
	$Option1.self_modulate.b = 0.8
	$Option2.self_modulate.b = 1

func select_option2():
	if $Option2.visible == false:
		return
	selected = option2
	$CanvasLayer/Arrow.position.x = $Option2.position.x
	$Option2.self_modulate.b = 0.8
	$Option1.self_modulate.b = 1

func select_option():
	if selected == null:
		shake()
		return
	
	$"Alert Sound".pitch_scale = 2
	$"Alert Sound".play()
	
	call(selected)
	stop_showing()

var enemies_drop_health_value = 0
var faster_reload_value = 0
var more_max_ammo_value = 0
var better_gun_value = 0
var longer_invincibility_value = 0
var asteroids_kill_enemies_value = 0
var asteroids_block_enemies_bullets_value = 0
var faster_movement_value = 0

@onready var player = $"../Player"


func get_description(text):
	if text == "enemies_drop_health":
		text = str("Life Steal\n\n\nWhen an enemy dies there is a ", upgrades["enemies_drop_health"][0], "% chance to regain health if you are below 3 hp")
	elif text =="faster_reload" :
		text = str("Faster Reaload\n\n\nYou reload ", upgrades["faster_reload"][0], "% faster")
	elif text == "more_max_ammo":
		text = str("More Ammo\n\n\nYou have ", upgrades["more_max_ammo"][0], " more ammo")
	elif text == "longer_invincibility":
		text = str("Heavy Armour\n\n\nYou gain ", upgrades["longer_invincibility"][0])
		if upgrades["longer_invincibility"][0] == 1:
			text += " more second of invincibility after being hit"
		else:
			text += " more seconds of invincibility after being hit"
	elif text == "faster_movement":
		text = str("Speedy Speed Boy\n\n\nYou move ", upgrades["faster_movement"][0],"% faster")
	elif text == "asteroids_kill_enemies":
		text = str("Fair Game\n\n\nAsteroids will kill enemies they collide with")
	elif text == "asteroids_block_enemies_bullets":
		text = str("Meat Shield\n\n\nAsteroids will block enemies' bullets")
	elif text == "better_gun":
		text = str("Heavy Artillery\n\n\nYour gun shoots ", upgrades["better_gun"][0])
		if upgrades["better_gun"][0] == 1:
			text += " more bullet"
		else:
			text += " more bullets"
	
	return text

var upgrades = {
	"enemies_drop_health" : [5,10,15,20,25],
	"faster_reload" : [15,30,45],
	"more_max_ammo" : [5,10,15,20,25],
	"longer_invincibility" : [2,3,4],
	"faster_movement": [20,40,60],
	"asteroids_kill_enemies" : [1],
	"asteroids_block_enemies_bullets" : [1],
	"better_gun" : [1,2],
}

var option1 = null
var option2 = null



func enemies_drop_health():
	enemies_drop_health_value = upgrades["enemies_drop_health"].pop_front()
	if upgrades["enemies_drop_health"].size() == 0:
		upgrades.erase("enemies_drop_health")


func faster_reload():
	faster_reload_value = upgrades["faster_reload"].pop_front()
	if upgrades["faster_reload"].size() == 0:
		upgrades.erase("faster_reload")
	
	player.bonus_reload = faster_reload_value

func more_max_ammo():
	more_max_ammo_value = upgrades["more_max_ammo"].pop_front()
	if upgrades["more_max_ammo"].size() == 0:
		upgrades.erase("more_max_ammo")
	
	player.bonus_max_ammo = more_max_ammo_value

func longer_invincibility():
	longer_invincibility_value = upgrades["longer_invincibility"].pop_front()
	if upgrades["longer_invincibility"].size() == 0:
		upgrades.erase("longer_invincibility")
	
	player.bonus_invincibility = longer_invincibility_value

func faster_movement():
	faster_movement_value = upgrades["faster_movement"].pop_front()
	if upgrades["faster_movement"].size() == 0:
		upgrades.erase("faster_movement")
	
	player.bonus_speed = faster_movement_value

func asteroids_kill_enemies():
	asteroids_kill_enemies_value = upgrades["asteroids_kill_enemies"].pop_front()
	if upgrades["asteroids_kill_enemies"].size() == 0:
		upgrades.erase("asteroids_kill_enemies")

func asteroids_block_enemies_bullets():
	asteroids_block_enemies_bullets_value = upgrades["asteroids_block_enemies_bullets"].pop_front()
	if upgrades["asteroids_block_enemies_bullets"].size() == 0:
		upgrades.erase("asteroids_block_enemies_bullets")

func better_gun():
	better_gun_value = upgrades["better_gun"].pop_front()
	if upgrades["better_gun"].size() == 0:
		upgrades.erase("better_gun")
	
	player.gun_level = better_gun_value



func show_upgrades():
	
	if $"../Hud/Death Menu".visible:
		return
	
	if upgrades.size() <= 0:
		return
	
	$CanvasLayer/Arrow.position.x = $Sprite2D.position.x
	
	$CanvasLayer.visible = true
	
	
	$"..".get_tree().paused = true
	
	var keys = upgrades.keys()
	
	
	option1 = keys[rng.randi_range(0,keys.size()-1)]
	option2 = keys[rng.randi_range(0,keys.size()-1)]
	
	if option1 == option2:
		if upgrades.size() > 1:
			option2 = keys[1]
			if option1 == option2:
				option2 = keys[0]
			
		else:
			option2 = "null"
			$Label2.visible = false
			$Option2.visible = false
			
	
	$Label1.text = get_description(option1)
	$Label2.text = get_description(option2)
	
	
	visible = true

func stop_showing():
	player.ammo = player.max_ammo + player.bonus_max_ammo
	
	
	selected = null
	$CanvasLayer.visible = false
	
	$Option2.self_modulate.b = 1
	$Option1.self_modulate.b = 1
	
	visible = false
	$"..".get_tree().paused = false
	
	$"..".pause_a_little()





var shaking = false
var ran_shake1 = null
var ran_shake2 = null
func shake():
	if shaking == true:
		return
	
	shaking = true
	
	
	$Option1.scale += Vector2(1,1)
	$Option2.scale += Vector2(1,1)
	
	$Option1.position += Vector2(-15,-15)
	$Option2.position += Vector2(15,-15)
	
	$Label1.position += Vector2(-15,-15)
	$Label2.position += Vector2(15,-15)
	
	
	$CanvasLayer/Arrow.scale += Vector2(4,4)
	
	$"Shake Timer".wait_time = 0.25
	$"Shake Timer".start()
	
	$"Alert Sound".pitch_scale = 1
	$"Alert Sound".play()

func _on_shake_timer_timeout():
	$Option1.scale -= Vector2(1,1)
	$Option2.scale -= Vector2(1,1)
	
	$Option1.position -= Vector2(-15,-15)
	$Option2.position -= Vector2(15,-15)
	
	$Label1.position -= Vector2(-15,-15)
	$Label2.position -= Vector2(15,-15)
	
	
	$CanvasLayer/Arrow.scale -= Vector2(4,4)
	
	shaking = false
