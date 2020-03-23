extends Area2D

func _ready():
	pass


func _on_grocery_body_entered(body):
	if body.get_name() == "player":
		body.add_groceries()
		
