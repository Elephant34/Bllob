extends Node2D


var global

func _on_Back_pressed():
	print("ummm not yet")
	
func _ready():
	global = get_tree().get_current_scene()
	
	global.say_hello()
