extends Node2D

onready var store_x = load("res://prefab/store_x.tscn")
onready var holding_bread = load("res://prefab/holding_bread.tscn")
onready var holding_drugs = load("res://prefab/holding_drugs.tscn")
onready var holding_flower = load("res://prefab/holding_flower.tscn")
onready var holding_toilet_paper = load("res://prefab/holding_toilet_paper.tscn")

onready var pickedup_sound = get_tree().get_root().get_node("game/audio/picked_up")
onready var empty_store_sound = get_tree().get_root().get_node("game/audio/empty_store")

var store_has_items = []
export var health = 1
var store_visited = false

func _ready():
	pass

func _on_grocery_body_entered(body):
	if body.get_name() == "player":

		var found_item = false
		for item in body.items_needed:
			if store_has_items.find(item) != -1:
				found_item = true
				if  body.items_holding.find(item) == -1:
					var holding_slot = body.find_node("holding_items").get_child(body.items_holding.size())
					var flower_slot = body.find_node("holding_items").find_node("flower_slot")
					body.items_holding.append(item)
					if item == "bread":
						holding_slot.add_child(holding_bread.instance())
					elif item == "toilet_paper":
						holding_slot.add_child(holding_toilet_paper.instance())
					elif item == "drugs":
						holding_slot.add_child(holding_drugs.instance())
					pickedup_sound.play()

		for item in body.items_bonus:
			if store_has_items.find(item) != -1:
				found_item = true
				if  body.items_holding_bonus.find(item) == -1:
					var holding_slot = body.find_node("holding_items").get_child(body.items_holding.size())
					var flower_slot = body.find_node("holding_items").find_node("flower_slot")
					body.items_holding_bonus.append(item)
					if item == "flower":
						flower_slot.add_child(holding_flower.instance())
					pickedup_sound.play()

		if found_item == false:
			if store_visited == false:
				store_visited = true
				var x_store = store_x.instance()
				x_store.position = Vector2(0, 0)
				add_child(x_store)
				empty_store_sound.play()
