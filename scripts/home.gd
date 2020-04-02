extends Area2D

onready var game = get_tree().get_root().get_node("game")
onready var sound_bad_home = get_tree().get_root().get_node(
	"game/audio/empty_store"
)

var first_enter

func _ready():
	first_enter = true

	pass

func _on_home_body_entered(body):
	if body.get_name() == "player":
		if global.level_type == "groceries":
			if body.items_holding.size() == body.items_needed.size():
				game.win_game()
			else:
				if not first_enter:
					sound_bad_home.play()
				first_enter = false
