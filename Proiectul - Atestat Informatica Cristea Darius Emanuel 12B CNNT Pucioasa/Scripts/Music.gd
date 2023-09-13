extends AudioStreamPlayer2D



func lower():
	pitch_scale = 0.5


func _on_finished():
	playing = true
