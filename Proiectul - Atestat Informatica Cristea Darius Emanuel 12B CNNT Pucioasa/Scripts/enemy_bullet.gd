extends CharacterBody2D


@export var damage = 1
@export var speed = 500


func _ready():
	velocity = Vector2(-1,0) * speed
	
	if get_parent().get_parent().get_parent().get_node("Upgrades").asteroids_block_enemies_bullets_value == 1:
		$Area2D.set_collision_mask_value(6, true)


func _process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()



func _on_area_2d_area_entered(area):
	queue_free()
