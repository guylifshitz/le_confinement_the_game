extends KinematicBody2D

# parameters
var SPEECH_SPEED = 0.15
var KIDS_INDEX = 2
var MOVE_SPEED = global.level_settings["enemies"]["move_speed"]

# conversation
var conversations_adult = global.game_settings["enemies"]["conversations_adult"]
var conversations_kid = global.game_settings["enemies"]["conversations_kid"]
var conversation
var conv_number = 0
var conv_page = 0
var conversation_timer

# navigation
var is_social = false
var follows_player = false
var navigation
var simple_path = PoolVector2Array()
var following_player_start_position
var remote_path_follow
var remote_transform

# objects
onready var dialog_box = get_node("speech/text")
onready var player = get_tree().get_root().get_node("game/elements/player")
onready var characters = $characters.get_children()

# other
var is_kid = false

func _ready():

	remote_path_follow.offset = randi() % 10000

	navigation = remote_transform.get_parent().get_parent().get_parent().get_parent()

	dialog_box.get_parent().hide()

	if randi() % 100 > (100 - global.level_settings["enemies"].knows_player_percentage):
		is_social = true
	else:
		dialog_box.get_parent().queue_free()

	for character in characters:
		character.hide()

	var character_number = randi()%characters.size()
	characters[character_number].show()
	if randf() > 0.5:
		characters[character_number].get_node("mask").hide()
	else:
		characters[character_number].get_node("mask").show()

	if character_number < KIDS_INDEX:
		conversation = conversations_kid[randi() % conversations_kid.size()]
	else:
		conversation = conversations_adult[randi() % conversations_adult.size()]


func _process(delta):
	if follows_player:
		var dir = (player.global_position - self.global_position).normalized()
		self.move_and_collide(dir * MOVE_SPEED * delta)
	else:
		if simple_path.size() > 0:
			move_along_path(MOVE_SPEED * delta)
		else:
			remote_path_follow.offset += MOVE_SPEED  * delta
			self.global_position = remote_transform.global_position


func move_along_path(distance):
	if distance == 0:
		return
	var start_point = global_position
	for i in range(simple_path.size()):
		var distance_to_next = start_point.distance_to(simple_path[0])

		if distance < distance_to_next and distance > 0.0:
			global_position = start_point.linear_interpolate(simple_path[0], distance/distance_to_next)
			break
		elif simple_path.size() == 1 && distance >= distance_to_next:
			global_position = simple_path[0]
#			set_process(false)

		distance -= distance_to_next
		start_point = simple_path[0]
		simple_path.remove(0)
		

func _on_social_distance_area_body_entered(body):
	if body.get_name() == "player" and is_social:
		follows_player = true
		
		start_conversation()
		if simple_path.size() == 0:
			following_player_start_position = self.global_position


func start_conversation():
	conv_page = 0
	dialog_box.set_text(conversation[conv_page])
	dialog_box.get_parent().show()
	if not conversation_timer:
		conversation_timer = utils_custom.create_timer_2(dialog_box.text.length() * SPEECH_SPEED, self, "dialog_next_page")


func dialog_next_page():
	conv_page = conv_page + 1
	
	if conv_page  >= conversation.size():
		conv_page = 0

	dialog_box.set_text(conversation[conv_page])
	conversation_timer = utils_custom.create_timer_2(dialog_box.text.length() * SPEECH_SPEED, self, "dialog_next_page")


func _on_social_distance_area_body_exited(body):
	if body.get_name() == "player" and is_social:
		follows_player = false
		simple_path = navigation.get_simple_path(global_position, following_player_start_position)
		dialog_box.get_parent().hide()
