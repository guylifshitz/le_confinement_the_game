extends Area2D

func _ready():
	pass


func _on_home_body_entered(body):
	if body.get_name() == "main_characterKinematic":
		body.remove_groceries()
		body.remove_drugs()
		