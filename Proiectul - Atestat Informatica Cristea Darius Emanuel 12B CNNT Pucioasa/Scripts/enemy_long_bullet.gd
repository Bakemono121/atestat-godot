extends CharacterBody2D


@export var damage = 1
@export var speed = 0.01

var laser_rotation = false

func _process(delta):
	if laser_rotation == true:
		rotate_laser()
	

var rotation_dir = -1
func rotate_laser():
	rotation += rotation_dir * speed

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.get_child(body_shape_index).name == "UpWall":
		rotation_dir = -1
	elif body.get_child(body_shape_index).name == "DownWall" or body.get_child(body_shape_index).name == "RightWall":
		rotation_dir = 1

