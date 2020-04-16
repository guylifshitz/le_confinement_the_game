extends Node2D

# onready var enemy_paths = self.get_children()
onready var enemies_holder = get_tree().get_root().get_node("game//elements/enemies_holder")

onready var new_enemy_base = load("res://prefab/Enemy.tscn")
onready var new_police_base = load("res://prefab/police.tscn")
onready var new_motorbike_base = load("res://prefab/motorbike.tscn")
onready var new_police_car_base = load("res://police_car.tscn")
export var enemy_type:String

func _ready():
	spawn()

func spawn():

	if "spawn_seed" in global.level_settings["enemies_per_path"][enemy_type]:
		seed(global.level_settings["enemies_per_path"][enemy_type]["spawn_seed"])
	else:
		seed(global.level_settings["spawn_seed"])
	
	var node_to_clone
	var spawn_distribution
	if enemy_type == "police":
		node_to_clone = new_police_base
		spawn_distribution = global.level_settings["enemies_per_path"]["police"]
	elif enemy_type == "motorbike":
		node_to_clone = new_motorbike_base
		spawn_distribution = global.level_settings["enemies_per_path"]["motorbike"]
	elif enemy_type == "police_car":
		node_to_clone = new_police_car_base
		spawn_distribution = global.level_settings["enemies_per_path"]["motorbike"]
	else:
		node_to_clone = new_enemy_base
		spawn_distribution = global.level_settings["enemies_per_path"]["pedestrians"]

	for path in spawn_distribution.keys():
		if path == "spawn_seed":
			continue
		var enemy_path = self.get_node(path)

		for i in range(0, spawn_distribution[path]):
			set_process(false)
			var new_enemy = node_to_clone.instance()
			new_enemy.position = Vector2(0, 0)
			new_enemy.add_to_group("enemies")

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
			enemies_holder.add_child(new_enemy)
			
