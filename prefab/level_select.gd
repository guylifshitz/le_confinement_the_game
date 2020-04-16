extends Node2D
export var level_number:String


func _on_Buttton_button_down():
	get_parent().get_parent().level_clicked(level_number)
