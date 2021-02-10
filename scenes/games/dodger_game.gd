extends Node2D


var global


func _ready():
	global = get_tree().get_current_scene()


func _on_Home_pressed():
	game_over()


func game_over():
	"""
	Counts up coins and goes back to home screen
	"""
	
	global.load_home()
