extends Path2D

onready var follow = get_node("PathFollow2D")
var tween

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(follow, "unit_offset", 0, 1, 6, tween.TRANS_EXPO, tween.EASE_IN_OUT)
	tween.set_repeat(true)
	follow.set("rotate", false)
	tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
