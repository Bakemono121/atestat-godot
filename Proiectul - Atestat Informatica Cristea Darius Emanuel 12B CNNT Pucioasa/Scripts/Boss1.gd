extends CharacterBody2D

var rng = RandomNumberGenerator.new()

@export var score_multiplier = 1
@export var damage = 1

var score = 150

@export var max_health = 400
var health = max_health


var min_shoot_time = 0.3
var max_shoot_time = 2


var speed = 150


func _ready():
	global_position.y = 204
	$"Shooting Timer".wait_time = rng.randf_range(min_shoot_time, max_shoot_time)
	$"Shooting Timer".start()
	
	$"Intent Chooser Timer".wait_time = 1
	$"Intent Chooser Timer".start()
	
	health = max_health
	
	$"Health Bar".max_value = max_health
	$"Health Bar".value = health
	
	intent_que = starting_intent_que.duplicate()
	
	if get_parent().get_parent().get_parent().get_node("Upgrades").asteroids_kill_enemies_value == 1:
		$PlayerHurtbox.set_collision_mask_value(6, true)


var movement_dir = Vector2(-1,0)
func _process(delta):
	velocity = movement_dir * speed
	
	move_and_collide(velocity * delta)
	
	if abs(movement_target.y - position.y) < 3:
		stop_movement()



func _on_player_hurtbox_area_entered(area):
	decrease_health(35)


func decrease_health(damage):
	health = health - damage
	$"Health Bar".value = health 
	if health <= 0:
		kill()

func kill():
	get_parent().get_parent().get_node("Sounds").add_child(death_sound.instantiate())
	get_parent().get_parent().get_parent().get_node("Player").score += score
	queue_free()


func _on_bullet_hurtbox_area_entered(area):
	decrease_health(area.get_parent().damage)


func _on_shooting_timer_timeout():
	shoot()

func shoot():
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = $"Gun Position".global_position
	get_parent().get_parent().get_node("Obstacles_List").add_child(bullet_instance)
	
	get_parent().get_parent().get_node("Sounds").add_child(bullet_sound.instantiate())
	
	$"Shooting Timer".wait_time = rng.randf_range(min_shoot_time, max_shoot_time)


func _on_movement_timer_timeout():
	movement_dir = Vector2(0,0)
	$Body/CollisionShape2D.disabled = false


@onready var player = get_parent().get_parent().get_parent().get_node("Player")
func shoot_giant_laser(time, type):
	$"Shooting Timer".paused = true
	
	var bullet_instance = long_bullet.instantiate()
	bullet_instance.position = $"Gun Position".position
	$Lasers.add_child(bullet_instance)
	add_child(bullet_sound.instantiate())
	
	
	if type == "regular":
		move_to_player_level()
		move_to_player_half(30)
	
	$"Stop Laser Timer".wait_time = time
	$"Stop Laser Timer".start()
	
	if type == "rotation":
		bullet_instance.laser_rotation = true
		bullet_instance.scale.x -= 14
	
	if time > 0:
		$"Intent Chooser Timer".wait_time = time
		$"Intent Chooser Timer".start()

var movement_target = Vector2(0,0)
func move_to_player_level():
	if player.position.y - position.y > 4:
		movement_dir.y = 1
	elif position.y - player.position.y >= 4:
		movement_dir.y = -1
	
	movement_target.y = player.position.y


func move_to_player_half(offset):
	$"Follow player timer".stop()
	
	if player.position.y - position.y > 4:
		movement_dir.y = 1
		movement_target = Vector2(0,408 - offset)
	elif position.y - player.position.y > 4:
		movement_dir.y = -1
		movement_target = Vector2(0,0 + offset)


func move_to_mid_level():
	$"Follow player timer".stop()
	
	if global_position.y < 204:
		movement_dir.y = 1
	else:
		movement_dir.y = -1
	
	movement_target = Vector2(0,204)

func _on_body_body_entered(body):
	stop_movement()

func stop_movement():
	movement_dir = Vector2(0,0)
	movement_target = Vector2(0,0)

func stop_laser():
	$"Shooting Timer".paused = false
	
	for child in $Lasers.get_children():
		child.queue_free()


var follow_player_pos = false
func follow_player(time):
	$"Follow player timer".wait_time = 0.1
	$"Follow player timer".start()
	
	if time > 0:
		$"Intent Chooser Timer".wait_time = time
		$"Intent Chooser Timer".start()


func _on_go_mid_y_timer_timeout():
	move_to_mid_level()


func _on_stop_laser_timer_timeout():
	stop_laser()


func _on_follow_player_timer_timeout():
	move_to_player_level()


var starting_intent_que = ["follow player 3","move to mid level", "warn regular laser",
 "one laser", "follow player 3", "move to mid level", "warn rotation laser",
 "one laser rotation",

 "no more intents"]

var intent_que = []

func intent_chooser():
	var intent = intent_que.pop_front()
	
	if intent == "one laser":
		shoot_giant_laser(3, "regular")
	
	elif intent == "one laser rotation":
		shoot_giant_laser(6, "rotation")
	
	elif intent == "follow player 3":
		follow_player(3)
	
	elif intent == "move to mid level":
		move_to_mid_level()
		$"Intent Chooser Timer".wait_time = 1
		$"Intent Chooser Timer".start()
	
	elif intent == "warn regular laser":
		warn_regular_laser(0.75)
	
	elif intent == "warn rotation laser":
		warn_rotation_laser(1.5)
	
	elif intent == "no more intents":
		intent_que = starting_intent_que.duplicate()
		intent_chooser()


func _on_intent_chooser_timer_timeout():
	intent_chooser()


func warn_regular_laser(warn_time):
	var warning = regular_laser_warning.instantiate()
	get_node("Lasers").add_child(warning)
	warning.set_destroy_time(warn_time)
	warning.position = $"Gun Position".position
	
	$"Intent Chooser Timer".wait_time = warn_time
	$"Intent Chooser Timer".start()

func warn_rotation_laser(warn_time):
	var warning = rotational_laser_warning.instantiate()
	get_parent().get_parent().get_node("Misc").add_child(warning)
	warning.set_destroy_time(warn_time)
	
	$"Intent Chooser Timer".wait_time = warn_time
	$"Intent Chooser Timer".start()


const bullet = preload("res://Scenes/enemy_bullet.tscn")
const bullet_sound = preload("res://sounds/enemy_bullet_sound.tscn")
const long_bullet = preload("res://Scenes/enemy_long_bullet.tscn")
const rotational_laser_warning = preload("res://Scenes/rotational_laser_warning.tscn")
const regular_laser_warning = preload("res://Scenes/regular_laser_warning.tscn")
const death_sound = preload("res://sounds/asteroid_explosion.tscn")
