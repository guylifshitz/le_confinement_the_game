extends Area2D

func _ready():
	pass




func _on_pharmacy_body_entered(body):
	if body.get_name() == "main_characterKinematic":
		body.add_drugs()
		