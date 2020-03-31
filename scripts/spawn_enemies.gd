extends Node2D

# onready var enemy_paths = self.get_children()
onready var enemies_holder = get_tree().get_root().get_node("game//elements/enemies_holder")

onready var new_enemy_base = load("res://prefab/Enemy.tscn")
onready var new_police_base = load("res://prefab/police.tscn")

export var enemy_type:String

func _ready():
	spawn()

func spawn():

	seed(1)
	
	var node_to_clone
	var spawn_distribution
	if enemy_type == "police":
		node_to_clone = new_police_base
		spawn_distribution = global.level_settings["enemies_per_path"]["police"]
	else:
		node_to_clone = new_enemy_base
		spawn_distribution = global.level_settings["enemies_per_path"]["enemies"]

	for path in spawn_distribution.keys():
		var enemy_path = self.get_node(path)

		for i in range(0, spawn_distribution[path]):
			var new_enemy = node_to_clone.instance()
			new_enemy.position = Vector2(0, 0)
			new_enemy.add_to_group("enemies")
			enemies_holder.add_child(new_enemy)

			# Should have used a Transform2D, but I was not able to get it to work.
			# Instead just set the global_position to this node
			var remote_transform = Node2D.new()	
			new_enemy.remote_transform = remote_transform

			var new_path_follow = PathFollow2D.new()
			new_path_follow.loop = true
			new_path_follow.rotate = false
			new_path_follow.offset = randi() % 10000
			
			new_path_follow.add_child(remote_transform)
			enemy_path.add_child(new_path_follow)

			new_enemy.remote_path_follow = new_path_follow

