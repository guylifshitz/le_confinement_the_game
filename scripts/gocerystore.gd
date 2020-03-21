extends Area2D

func _ready():
	pass


func _on_Area2D_body_entered(body):
	if body.get_name() == "main_characterKinematic":
		body.add_groceries()
		
