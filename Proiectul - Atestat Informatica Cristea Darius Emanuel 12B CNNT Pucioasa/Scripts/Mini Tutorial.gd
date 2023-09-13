extends Node2D



func _on_self_destruct_timer_timeout():
	queue_free()
