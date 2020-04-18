extends Node2D

var current_store_name
onready var player = get_tree().get_root().get_node("game/elements/player")


func _ready():
	if "change_item_location" in global.level_settings:
		handle_store_item_changing()


func handle_store_item_changing():
	var sprite = Sprite.new()

	if self.get_children().size() > 0:
		var child_store = self.get_child(0)
		var child_store_node = get_tree().get_root().get_node(
			"game/elements/goals/" + current_store_name + "/store_node"
		)
		child_store_node.store_has_items = []
		child_store.queue_free()

	var store_options = global.level_settings["change_item_location"]["stores"].duplicate(true)
	var closest_store = find_nearest_store()
	store_options.erase(closest_store)
	var store_name = store_options[randi() % store_options.size()]
	sprite.set_texture(load("res://images/goals/" + store_name + ".png"))
	self.add_child(sprite)

	utils_custom.create_timer_2(
		global.level_settings["change_item_location"]["time_frequency"],
		self,
		"handle_store_item_changing"
	)

	var store_node = get_tree().get_root().get_node(
		"game/elements/goals/" + store_name + "/store_node"
	)
	store_node.store_visited = false
	store_node.store_has_items = global.level_settings["change_item_location"]["item"]
	current_store_name = store_name

	var x_icon = store_node.get_node("X")
	if x_icon:
		x_icon.queue_free()


func find_nearest_store():
	var stores = get_tree().get_root().get_node("game/elements/goals").get_children()
	var nearest_store
	if stores.size() > 0:
		for store in stores:
			if store.name in global.level_settings["change_item_location"]["stores"]:
				if nearest_store:
					if (
						store.global_position.distance_to(player.global_position)
						< nearest_store.global_position.distance_to(player.global_position)
					):
						nearest_store = store
				else:
					nearest_store = store
	return nearest_store.name
