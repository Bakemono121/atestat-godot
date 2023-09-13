extends CharacterBody2D

@export var health = 3
@export var speed = 250
@export var cooldown_timer = 0.2
@export var max_ammo = 10
@export var ammo_refresh_rate = 0.5

var invincibility_time = 1.0
var ammo = max_ammo

var score = 0

var bonus_reload = 0
var bonus_max_ammo = 0
var bonus_invincibility = 0
var bonus_speed = 0
var gun_level = 0


func _ready():
	get_node("AmmoRefreshTimer").wait_time = ammo_refresh_rate

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * (speed + speed * (0.01 * bonus_speed))
	
	if Input.is_action_pressed("shoot"):
		shoot()



var cooldown = false
func _on_timer_timeout():
	cooldown = false


func shoot():
	if not cooldown and ammo > 0:
		add_child(bullet_sound.instantiate())
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = $"Gun Position".global_position
		get_parent().add_child(bullet_instance)
		
		if gun_level > 0:
			bullet_instance = bullet.instantiate()
			bullet_instance.position = $"Gun Position".global_position
			bullet_instance.position.y -= 5
			get_parent().add_child(bullet_instance)
		if gun_level == 2:
			bullet_instance = bullet.instantiate()
			bullet_instance.position = $"Gun Position".global_position
			bullet_instance.position.y += 5
			get_parent().add_child(bullet_instance)
		
		cooldown = true
		get_node("ShootingTimer").wait_time = cooldown_timer
		get_node("ShootingTimer").start()
		
		ammo -= 1
		get_node("AmmoRefreshTimer").wait_time = ammo_refresh_rate - ammo_refresh_rate * (bonus_reload * 0.01)
		get_node("AmmoRefreshTimer").start()

func _physics_process(delta):
	get_input()
	move_and_slide()

func _on_ammo_refresh_timer_timeout():
	increase_ammo()
	
	if ammo < (max_ammo + bonus_max_ammo):
		get_node("AmmoRefreshTimer").start()

func increase_ammo():
	if ammo < (max_ammo + bonus_max_ammo):
		ammo += 1

func _on_hurtbox_area_entered(area):
	decrease_health(area.get_parent().damage)


func decrease_health(damage):
	$Sounds.add_child(crash_sound.instantiate())
	
	health -= damage
	if health <= 0:
		kill()
	
	if Save.save_dict["controller_vibration"] == "true":
		Input.start_joy_vibration(0,0.3,0.3,0.75)
	
	call_deferred("give_invincibility", invincibility_time + bonus_invincibility)

func kill():
	get_parent().get_node("Music").lower()
	get_parent().add_child(death_sound.instantiate())
	
	get_parent().get_node("Hud/Info").process_mode = Node.PROCESS_MODE_DISABLED
	get_parent().get_node("Hud/Info").visible = false
	
	get_parent().get_node("Hud/Death Menu").visible = true
	get_parent().get_node("Hud/Death Menu/Score").text += str(score)
	
	$"../Enemy Controller/Enemy_List".process_mode = Node.PROCESS_MODE_DISABLED
	$"../Enemy Controller/Enemy_List".visible = false
	
	Save.load_game()
	
	if score > int(Save.save_dict["high_score"]):
		Save.save_dict["high_score"] = str(score)
	
	Save.save_game()
	get_parent().get_node("Hud/Death Menu/High Score").text += str(Save.save_dict["high_score"])
	queue_free()


var flicker_count = 0
var flicker_time = 0
func give_invincibility(time):
	$Hurtbox/CollisionShape2D2.disabled = true
	$Invincibility_Timer.wait_time = time
	$Invincibility_Timer.start()
	
	modulate.a = 0.75
	flicker_count = time * 8
	flicker_time = time/8
	$Flickering_Timer.wait_time = flicker_time
	$Flickering_Timer.start()


func _on_invincibility_timer_timeout():
	$Hurtbox/CollisionShape2D2.disabled = false
	flicker_count = 0
	modulate.a = 1


func _on_flickering_timer_timeout():
	flicker_count -= 1
	if flicker_count > 0:
		$Flickering_Timer.wait_time = flicker_time
		$Flickering_Timer.start()
		if modulate.a == 1:
			modulate.a = 0.75
		else:
			modulate.a = 1

func increase_health(value):
	health += value
	$Sounds.add_child(healing_sound.instantiate())

const bullet = preload("res://Scenes/bullet.tscn")
const bullet_sound = preload("res://sounds/bullet.tscn")
const death_sound = preload("res://sounds/death.tscn")
const crash_sound = preload("res://sounds/asteroid_explosion.tscn")
const healing_sound = preload("res://sounds/healing.tscn")
