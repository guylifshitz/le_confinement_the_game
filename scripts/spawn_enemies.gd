extends Node2D

onready var enemy_paths = self.get_children()
onready var new_enemy_base = load("res://prefab/Enemy.tscn")

func _ready():
	spawn()

func spawn():
	#while true:
	for i in range(0,20):
		var new_enemy = new_enemy_base.instance()
		new_enemy.position = Vector2(0, 0)
		new_enemy.add_to_group("enemies")
		var enemy_path = enemy_paths[randi() % enemy_paths.size()]
		var new_path = enemy_path.duplicate()
		new_path.show()

		var new_path_follow = PathFollow2D.new()
		new_path_follow.loop = true
		new_path_follow.add_child(new_enemy)
		new_path.add_child(new_path_follow)
		new_path_follow.rotate = false
		new_path_follow.offset = randi() % 1000000
		add_child(new_path)

		#yield(utils_custom.create_timer(0.1), "timeout")
