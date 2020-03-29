extends Area2D

onready var game = get_tree().get_root().get_node("game")

func _ready():
	pass


func _on_home_body_entered(body):
	if body.get_name() == "player":
		#if body.items_needed.sort() == body.items_holding.sort():
	#		print("AAA")
#		var holding_slots = body.find_node("holding_items")
#		for holding_slot in holding_slots.get_children():
#			delete_children(holding_slot)
#		body.items_holding = []
		if body.items_holding.size() == body.items_needed.size():
			game.win_game()

#static func delete_children(node):
#	for n in node.get_children():
#		node.remove_child(n)
#		n.queue_free()
#
