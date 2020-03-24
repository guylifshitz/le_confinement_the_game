extends Area2D

func _ready():
	pass


func _on_home_body_entered(body):
	if body.get_name() == "player":
		#if body.items_needed.sort() == body.items_holding.sort():
		var holding_slots = body.find_node("holding_items")
		for holding_slot in holding_slots.get_children():
			delete_children(holding_slot)
		body.items_holding = []

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

