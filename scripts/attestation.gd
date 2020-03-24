extends Sprite

func _ready():
	pass # Replace with function body.



func _on_attestation_body_entered(body):
	if body.name == "player":
		self.get_parent().queue_free()
		body.acquired_attestation()
		
