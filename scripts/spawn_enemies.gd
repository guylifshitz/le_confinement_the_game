extends Node2D

onready var enemy_paths = self.get_children()
onready var game_settings = get_tree().get_root().get_node("game").game_settings

onready var new_enemy_base = load("res://prefab/Enemy.tscn")
onready var new_police_base = load("res://prefab/police.tscn")

export var enemy_type:String

func _ready():
	spawn()

func spawn():

	seed(1)
	
	var spawn_count
	var node_to_clone
	if enemy_type == "police":
		spawn_count = game_settings["police"]["count"]
		node_to_clone = new_police_base
	else:
		spawn_count = game_settings["enemies"]["count"]
		node_to_clone = new_enemy_base

	for i in range(0, spawn_count):
		var new_enemy
		new_enemy = node_to_clone.instance()
			
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
