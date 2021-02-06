extends Node2D


var global


func _ready():
	global = get_tree().get_current_scene()
