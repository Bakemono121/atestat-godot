extends ParallaxBackground

var rng = RandomNumberGenerator.new()

func _ready():
	$ParallaxLayer2/Sprite2D.position = Vector2(rng.randi_range(620,720), rng.randi_range(0,405))

func _process(delta):
	scroll_base_offset -= Vector2(10000,0) * delta
