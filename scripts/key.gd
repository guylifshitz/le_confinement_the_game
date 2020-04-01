extends YSort

var respawn_time = global.level_settings["attestation"]["respawn_time"]

func _ready():
	pass # Replace with function body.

func _on_key_body_entered(body):
	if body.name == "player" and self.visible:
		body.acquired_key()
		queue_free()

