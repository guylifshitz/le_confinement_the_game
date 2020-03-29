extends Node2D

var mouse_over = false

#func _input(event):
#	# mouse input
#	if event is InputEventMouseButton:
#		if mouse_over == true:
#
#	# keyboard input
#	if event.is_action_pressed('ui_toggleFullscreen'):
#		OS.window_fullscreen = !OS.window_fullscreen
#


#func _on_Button_button_down():
#	OS.window_fullscreen = !OS.window_fullscreen
#	$Button.disabled = true
#	utils_custom.create_timer_2(0.1, self, "reenable_button")

func reenable_button():
	$Button.disabled = false


func _on_Button_button_up():
	OS.window_fullscreen = !OS.window_fullscreen
