extends Node

onready var enemy_paths = $EnemyPaths.get_children()
onready var enemy = $Enemy
onready var new_enemy_base = load("res://Enemy.tscn")



func _ready():
	spawn()

func spawn():
	while true:
		var new_enemy = new_enemy_base.instance()
		new_enemy.position = Vector2(2, 2)
		#get_tree().call_group(0, "groupName", "connect", .....)
		new_enemy.add_to_group("enemies")
		var enemy_path = enemy_paths[randi() % enemy_paths.size()]

		var new_path = enemy_path.duplicate()
		var new_path_follow = PathFollow2D.new()
		new_path_follow.add_child(new_enemy)
		new_path.add_child(new_path_follow)
		new_path_follow.rotate = false
		new_path_follow.unit_offset = 0
		add_child(new_path)
		
	
		var tween = Tween.new()	
		new_path.add_child(tween)
		tween.interpolate_property(new_path_follow, "unit_offset",0,1,10,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
		yield(utils_custom.create_timer(0.5), "timeout")

	
