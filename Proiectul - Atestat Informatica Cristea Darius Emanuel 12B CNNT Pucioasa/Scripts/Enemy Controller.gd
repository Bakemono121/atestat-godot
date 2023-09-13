extends Node2D

var min_spawn_rate = 3
var max_spawn_rate = 5
var min_spawn = 0
var max_spawn = 400
var min_target = -0.25
var max_target = 0.25
var boss_wave = 3
var wave = 1
var enemy_count = 0

var rng = RandomNumberGenerator.new()

func _ready():
	spawn_wave()

func _on_spawn_timer_timeout():
	get_node("Spawn_Timer").wait_time = rng.randf_range(min_spawn_rate, max_spawn_rate)
	spawn_asteroid()

func spawn_asteroid():
	var asteroid_instance = asteroid_path.instantiate()
	asteroid_instance.position.x = get_node("Default Position").position.x
	asteroid_instance.position.y = rng.randf_range(min_spawn, max_spawn)
	asteroid_instance.target.y = rng.randf_range(min_target, max_target)
	get_node("Obstacles_List").add_child(asteroid_instance)


var formations = {
	"0": [Vector2(1,1)],
	"1": [Vector2(1,1), Vector2(1,2)],
	"2": [Vector2(1,1), Vector2(3,1)],
	"3": [Vector2(1,1), Vector2(2,1), Vector2(3,1)],
	"4": [Vector2(1,2), Vector2(2,1), Vector2(3,2)],
	"5": [Vector2(1,1), Vector2(3,1), Vector2(5,1)],
	"6": [Vector2(1,1), Vector2(1,2), Vector2(2,1), Vector2(2,2)],
	"7": [Vector2(1,1), Vector2(1,2), Vector2(3,1), Vector2(3,2)],
	"8": [Vector2(1,1), Vector2(2,1), Vector2(3,1), Vector2(4,1)],
	"9": [Vector2(1,2), Vector2(2,1), Vector2(4,1), Vector2(5,2)],
	"10": [Vector2(1,2), Vector2(2,1), Vector2(3,1), Vector2(4,1), Vector2(5,2)],
	"11": [Vector2(1,1), Vector2(1,2), Vector2(2,1), Vector2(3,1), Vector2(3,2)],
	"12": [Vector2(1,3), Vector2(2,2), Vector2(3,1), Vector2(4,2), Vector2(5,3)],
	"13": [Vector2(1,1), Vector2(2,1), Vector2(3,1), Vector2(1,2), Vector2(2,2), Vector2(3,2)],
}

func spawn_wave():
	var enemies_to_spawn = (wave - boss_counter) * 5
	var keys = formations.keys()
	
	var offset_x = 200
	var j = -1
	while enemies_to_spawn > 0:
		j += 1
		
		var formation
		
		var count = rng.randi_range(1,6)
		if count > enemies_to_spawn:
			count = enemies_to_spawn
		enemies_to_spawn -= count
		
		if count == 1:
			formation = keys[rng.randi_range(0,0)]
		elif count == 2:
			formation = keys[rng.randi_range(1,2)]
		elif count == 3:
			formation = keys[rng.randi_range(3,5)]
		elif count == 4:
			formation = keys[rng.randi_range(6,9)]
		elif count == 5:
			formation = keys[rng.randi_range(10,12)]
		elif count == 6:
			formation = keys[rng.randi_range(13,13)]
		
		var max_offset_y = 10 - formations[formation][formations[formation].size()-1].x
		var offset_y = rng.randi_range(0,max_offset_y)
		for i in count:
			spawn_formation(j * offset_x, offset_y, formation, i)


func spawn_formation(offset_x, offset_y, formation, i):
	var enemy_instance = enemy_1_path.instantiate()
	get_node("Enemy_List").add_child(enemy_instance)
	enemy_instance.position.x = formations[formation][i].y * 40 - 16 + get_node("Default Position").position.x + offset_x
	enemy_instance.position.y = (formations[formation][i].x + offset_y) * 40 - 16
	enemy_count += 1


func decrease_enemy_count():
	enemy_count -= 1
	if enemy_count > 0:
		return
	
	for child in $Obstacles_List.get_children():
		child.queue_free()
	$"../Upgrades".show_upgrades()
	
	wave += 1
	if wave % boss_wave == 0:
		call_deferred("start_boss_wave")
	else:
		start_next_wave()

var boss_counter = 0
func start_boss_wave():
	var enemy_instance = boss_1_path.instantiate()
	enemy_instance.position.x = get_node("Default Position").position.x
	enemy_instance.position.y = get_node("Default Position").position.y
	enemy_instance.max_health += boss_counter * 400
	get_node("Enemy_List").add_child(enemy_instance)
	enemy_count += 1
	
	boss_counter += 1



func start_next_wave():
	call_deferred("spawn_wave")
	
	for i in $Misc.get_children():
		i.queue_free()

func _on_enemy_list_child_exiting_tree(node):
	decrease_enemy_count()

func _on_sounds_child_entered_tree(node):
	if $Sounds.get_child_count() > 2:
		$Sounds.get_children()[0].queue_free()

const boss_1_path = preload("res://Scenes/boss_1.tscn")
const enemy_1_path = preload("res://Scenes/enemy_1.tscn")
const asteroid_path = preload("res://Scenes/asteroid.tscn")
