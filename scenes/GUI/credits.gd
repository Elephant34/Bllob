extends Control


var global

func _ready():
	global = get_tree().get_current_scene()


func _on_MenuButton_pressed():
	global.load_main_menu()
