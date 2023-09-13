extends Node2D


func _ready():
	pause_a_little()


func _on_start_timer_timeout():
	if get_node("Hud/Menu").visible == false:
		get_tree().paused = false

func pause_a_little():
	
	get_node("Start Timer").wait_time = 0.3
	get_node("Start Timer").start()
	
	get_tree().paused = true
