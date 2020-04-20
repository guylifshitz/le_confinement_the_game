extends Node2D

onready var store_x = load("res://prefab/store_x.tscn")
onready var holding_bread = load("res://prefab/holding_bread.tscn")
onready var holding_drugs = load("res://prefab/holding_drugs.tscn")
onready var holding_flower = load("res://prefab/holding_flower.tscn")
onready var holding_duck = load("res://prefab/holding_duck.tscn")
onready var holding_toilet_paper = load("res://prefab/holding_toilet_paper.tscn")
onready var holding_pasta = load("res://prefab/holding_pasta.tscn")
onready var holding_sanitizer = load("res://prefab/holding_sanitizer.tscn")

onready var pickedup_sound = get_tree().get_root().get_node("game/audio/picked_up")
onready var empty_store_sound = get_tree().get_root().get_node("game/audio/empty_store")

var store_has_items = []
export var show_x_on_empty = true
var store_visited = false


func _ready():
	pass


func _on_grocery_body_entered(body):
	if body.get_name() == "player" and global.level_type == "groceries":
		var found_item = false
		for item in body.items_needed:
			if store_has_items.find(item) != -1:
				found_item = true
				if body.items_holding.find(item) == -1:
					var holding_slot = body.find_node("holding_items").get_child(
						body.items_holding.size()
					)
					body.items_holding.append(item)

					var item_to_hold = load("res://prefab/holding_" + item + ".tscn")
					holding_slot.add_child(item_to_hold.instance())

					pickedup_sound.play()

		for item in body.items_bonus:
			if store_has_items.find(item) != -1:
				found_item = true
				if body.items_holding_bonus.find(item) == -1:
					var holding_slot = body.find_node("holding_bonus_items").get_child(
						body.items_holding_bonus.size()
					)
					body.items_holding_bonus.append(item)

					var item_to_hold = load("res://prefab/holding_" + item + ".tscn")
					holding_slot.add_child(item_to_hold.instance())

					pickedup_sound.play()

		if found_item == false and show_x_on_empty:
			if store_visited == false:
				store_visited = true
				var x_store = store_x.instance()
				x_store.position = Vector2(0, 0)
				x_store.name = "X"
				add_child(x_store)
				empty_store_sound.play()
