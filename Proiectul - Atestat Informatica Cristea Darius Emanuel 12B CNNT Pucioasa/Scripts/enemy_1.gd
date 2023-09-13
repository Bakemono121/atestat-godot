extends CharacterBody2D


@export var score_multiplier = 1
@export var damage = 1

var score = 15

var max_health = 30
var health = max_health


var min_shoot_time = 1
var max_shoot_time = 4


var speed = 75



var rng = RandomNumberGenerator.new()

func _ready():
	$"Shooting Timer".wait_time = rng.randf_range(min_shoot_time, max_shoot_time) + 0.5
	$"Shooting Timer".start()
	
	if get_parent().get_parent().get_parent().get_node("Upgrades").asteroids_kill_enemies_value == 1:
		$PlayerHurtbox.set_collision_mask_value(6, true)
	


var movement_dir = Vector2(-1,0)

func _process(delta):
	
	velocity = movement_dir * speed
	
	var collision = move_and_collide(velocity * delta)



func _on_player_hurtbox_area_entered(area):
	kill()

func decrease_health(damage):
	
	health = health - damage
	if health <= 0:
		kill()

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
func kill():
	var chance = get_parent().get_parent().get_parent().get_node("Upgrades").enemies_drop_health_value
	var test = rng.randi_range(0,100)
	if player.health < 3 and chance >= test:
		player.increase_health(1)
	
	get_parent().get_parent().get_node("Sounds").add_child(death_sound.instantiate())
	get_parent().get_parent().get_parent().get_node("Player").score += score
	queue_free()


func _on_bullet_hurtbox_area_entered(area):
	decrease_health(area.get_parent().damage)


func _on_shooting_timer_timeout():
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = $"Gun Position".global_position
	get_parent().get_parent().get_node("Obstacles_List").add_child(bullet_instance)
	
	if position.x <= 716:
		get_parent().get_parent().get_node("Sounds").add_child(bullet_sound.instantiate())
	
	$"Shooting Timer".wait_time = rng.randf_range(min_shoot_time, max_shoot_time)

const bullet = preload("res://Scenes/enemy_bullet.tscn")
const bullet_sound = preload("res://sounds/enemy_bullet_sound.tscn")
const death_sound = preload("res://sounds/asteroid_explosion.tscn")
