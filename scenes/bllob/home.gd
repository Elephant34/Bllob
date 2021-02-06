extends Node2D


var global


func _ready():
	"""
	Called when home screen added to global
	"""
	global = get_tree().get_current_scene()
	
	load_bllobs()

func load_bllobs():
	"""
	Load the blobs to be visible in scene
	"""
	
	for bllob_id in global.bllob_data:
		global.loaded_bllobs[bllob_id] = global.bllob_prescene.instance()
		
		# Sets up the needed bllob variables before it can be added
		global.loaded_bllobs[bllob_id].setup(bllob_id, "home")
		
		add_child(global.loaded_bllobs[bllob_id])
