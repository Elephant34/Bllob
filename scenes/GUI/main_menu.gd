extends Control


var global

func _ready():
	"""
	Gets the main menu ready
	"""
	global = get_tree().get_current_scene()
	
	# Gives the DemoBllobs random colours
	$DemoBllob.modulate = Color(randf(), randf(), randf())
	$DemoBllob2.modulate = Color(randf(), randf(), randf())


func _on_ExitButton_pressed():
	"""
	Exits the game
	"""
	global.quit_game()


func _on_PlayButton_pressed():
	"""
	Loads the game home screne
	"""
	global.load_home()
