extends CharacterBody2D


@export var damage = 15
@export var speed = 500


func _ready():
	velocity = Vector2(1,0) * speed

func _process(delta):
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()



func _on_area_2d_area_entered(area):
	queue_free()
