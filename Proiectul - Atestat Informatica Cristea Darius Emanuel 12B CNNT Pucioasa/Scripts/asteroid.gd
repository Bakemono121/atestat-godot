extends CharacterBody2D

@export var score_multiplier = 1
@export var damage = 1

var score
var health
var speed
var min_scale = 0.5
var max_scale = 3

var target = Vector2(-1,0)

var rng = RandomNumberGenerator.new()

const explosion = preload("res://sounds/asteroid_explosion.tscn")

func _ready():
	get_random_values()
	velocity = target * speed
	if get_parent().get_parent().get_parent().get_node("Upgrades").asteroids_block_enemies_bullets_value == 1:
		$BulletHurtbox.set_collision_mask_value(8, true)
	if get_parent().get_parent().get_parent().get_node("Upgrades").asteroids_kill_enemies_value == 1:
		$PlayerHurtbox.set_collision_mask_value(4, true)

func _process(delta):
	var collision = move_and_collide(velocity * delta)
	rotation += rotation_speed

var rotation_speed = 0.05
var size = 1
func get_random_values():
	size = rng.randf_range(min_scale, max_scale)
	scale = Vector2(size, size)
	speed = 275 - size * 50
	health = int(size * 30)
	score = int(size * 10)
	rotation_speed = (max_scale - size ) * 0.015


var last_hit = "player"
func _on_area_2d_area_entered(area):
	
	var damage_multiplier = 1
	
	if area.collision_layer == 128:
		damage_multiplier = 50
		last_hit = "enemy"
	if  area.collision_layer == 256:
		damage_multiplier = 150
		last_hit = "enemy"
		
	decrease_health(area.get_parent().damage * damage_multiplier)
	

func _on_player_hurtbox_area_entered(area):
	if area.collision_layer == 128:
		last_hit = "enemy"
	kill()

func decrease_health(damage):
	
	health = health - damage
	if health <= 0:
		kill()

func kill():
	
	get_parent().get_parent().get_node("Sounds").add_child(explosion.instantiate())
	if last_hit == "player":
		get_parent().get_parent().get_parent().get_node("Player").score += score
	
	queue_free()



