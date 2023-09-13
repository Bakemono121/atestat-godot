extends Node2D


func set_destroy_time(destroy_time):
	$"Destroy Timer".wait_time = destroy_time
	$"Destroy Timer".start()

func _on_timer_timeout():
	visible = not visible

func _on_destroy_timer_timeout():
	queue_free()
