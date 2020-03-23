extends KinematicBody2D

var is_social = false
var follows_player = false
var simple_path = PoolVector2Array()
var following_player_start_position
var navigation

# PARAMS
var knows_player_percentage = 100
var MOVE_SPEED = 100

# conversation
var conversations = [["Hey!", "How are you?"],
					["Wanna play?    "],
					["Salut!", "On fait la bise?"],
					["Une clope?"]]
var conv_number = 0
var conv_page = 0
onready var dialog_box = get_node("speech").get_node("text")
onready var test = get_tree()
onready var test2 = get_tree().get_root()
onready var player = get_tree().get_root().get_node("game/elements/player")

func _ready():
	navigation = get_parent().get_parent().get_parent().get_parent()

	dialog_box.get_parent().hide()

	conv_number = randi() % conversations.size()

	if randi() % 100 > (100 - knows_player_percentage):
		is_social = true
	else:
		dialog_box.get_parent().queue_free()

func _process(delta):

	if following_player_start_position:
		find_node("spot").global_position = following_player_start_position

	if follows_player:
		var dir = (player.global_position - self.global_position).normalized()
		self.move_and_collide(dir * MOVE_SPEED * delta)
#		find_node("enemySprite").modulate = Color(0.2,0.2,0.2)
	else:
		if simple_path.size() > 0:
			move_along_path(MOVE_SPEED * delta)
#			find_node("enemySprite").modulate = Color(1,0,1)
		else:
			self.get_parent().offset += MOVE_SPEED  * delta
#			find_node("enemySprite").modulate = Color(0,0,1)
	

func _on_social_distance_area_body_entered(body):
	if body.get_name() == "player" and is_social:
		follows_player = true
		
		if simple_path.size() == 0:
			start_conversation()
			following_player_start_position = self.global_position

func start_conversation():
	conv_page = 0
	dialog_box.set_text(conversations[conv_number][conv_page])
	dialog_box.get_parent().show()
	utils_custom.create_timer_2(dialog_box.text.length() * 0.1, self, "dialog_next_page")

func dialog_next_page():
	conv_page = conv_page + 1
	if conv_page  >= conversations[conv_number].size():
		dialog_box.get_parent().hide()
	else:
		dialog_box.set_text(conversations[conv_number][conv_page])
		utils_custom.create_timer_2(dialog_box.text.length() * 0.1, self, "dialog_next_page")
		
func _on_social_distance_area_body_exited(body):
	if body.get_name() == "player" and is_social:
		follows_player = false
		simple_path = navigation.get_simple_path(global_position, following_player_start_position)
	
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
