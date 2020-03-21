extends Area2D

func _ready():
	pass


func _on_home_body_entered(body):
	print("Home")
	print(body.name)

	if body.get_name() == "main_characterKinematic":
		body.remove_groceries()
		body.remove_drugs()
		
