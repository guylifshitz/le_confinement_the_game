extends Node2D

var dialog_chunks = ["*Cough*Cough*", "Je ne me sens pas bien."]
var dialog_chunk = 0

func _ready():
	update_text()
	pass

func update_text():
	dialog_chunk += 1
	if dialog_chunk == dialog_chunks.size():
		get_tree().change_scene("res://level_bastille.tscn")
	else:
		$RichTextLabel.text = $RichTextLabel.text + dialog_chunks[dialog_chunk - 1]
		utils_custom.create_timer_2(3, self, "update_text")


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		update_text()
