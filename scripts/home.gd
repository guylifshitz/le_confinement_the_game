extends Area2D

onready var game = get_tree().get_root().get_node("game")

func _ready():
	pass

func _on_home_body_entered(body):
	if body.get_name() == "player":
		if body.items_holding.size() == body.items_needed.size():
			game.win_game()
