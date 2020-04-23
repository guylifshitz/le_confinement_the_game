extends PathFollow2D

var prev_x = 0
var prev_y = 0

onready var swan_1 = get_node("swan_1")
onready var swan_2 = get_node("swan_2")


func _ready():
	self.get_parent().show()
	pass


func _process(delta):
	if prev_x < swan_1.global_position.x and prev_y > swan_1.global_position.y:
		swan_1.play("right")
		swan_2.play("right")
	elif prev_x < swan_1.global_position.x and prev_y < swan_1.global_position.y:
		swan_1.play("right")
		swan_2.play("right")
	elif prev_x > swan_1.global_position.x and prev_y < swan_1.global_position.y:
		swan_1.play("down")
		swan_2.play("down")
	else:
		swan_1.play("left")
		swan_2.play("left")

	prev_x = swan_1.global_position.x
	prev_y = swan_1.global_position.y
	
	self.offset += 60 * delta
