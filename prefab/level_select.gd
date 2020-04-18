extends Node2D

func _on_Buttton_button_down():
	get_parent().get_parent().level_clicked(self.name)
