extends Area2D

func _ready():
	pass


func _on_Area2D_body_entered(body):
	print("Franproix")
	print(body.name)

	if body.get_name() == "main_characterKinematic":
		body.add_groceries()
		
