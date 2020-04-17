extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_green()
	pass # Replace with function body.

func set_green():
	$"red-R".hide()
	$"yellow-R".hide()
	$"geen-R".show()
	$"red-L".show()
	$"yellow-L".hide()
	$"green-L".hide()
	utils_custom.create_timer_2(3, self, "set_yellow")

func set_yellow():
	$"red-R".hide()
	$"yellow-R".show()
	$"geen-R".hide()
	$"red-L".show()
	$"yellow-L".hide()
	$"green-L".hide()
	utils_custom.create_timer_2(3, self, "set_red")

func set_red():
	$"red-R".show()
	$"yellow-R".hide()
	$"geen-R".hide()
	$"red-L".hide()
	$"yellow-L".hide()
	$"green-L".show()
	utils_custom.create_timer_2(3, self, "set_yellow_2")
	
func set_yellow_2():
	$"red-R".show()
	$"yellow-R".hide()
	$"geen-R".hide()
	$"red-L".hide()
	$"yellow-L".show()
	$"green-L".hide()
	utils_custom.create_timer_2(3, self, "set_green")
