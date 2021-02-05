extends Node2D


var global

var selected_bllob_id


# Default timer seconds
var appetite_count = 5
var satisfaction_count = 5
var aging_count = 20

var autosave_count = 30

# ===========================
# Overwridden game functions
# ===========================

func _ready():
	# Connects all signals to functions
	connect_signals()
	
	global = get_tree().get_current_scene()
	
	$AutoSave.wait_time = autosave_count
	$Aging.wait_time = aging_count
	
	# Adds all saved bllobs
	for bllob_id in global.bllob_data:
		instance_bllob(bllob_id)
	
	update_coin_count(0)

func _process(dt):
	
	if $GUI/Node/BllobPanel.visible:
		$GUI.show_bllob_panel(selected_bllob_id, global.bllob_data[selected_bllob_id])
	
	# Displays the game time
	# TODO format the time into a human friendly counter
	$GUI/Node/Time.text = "Time: %.2f" % global.raw_time


# =======
# Other
# =======


func connect_signals():
	"""
	Connects any signals from button presses to functions
	"""
	
	$GUI/Node/MenuPanel/ShopPanel/Egg.connect("pressed", self, "_on_Egg_purchesed")
	$GUI/Node/MenuPanel/GamesPanel/Dodger.connect("pressed", self, "_on_Dodger_pressed")


# ===============
# Bllob methods
# ===============

func _on_Aging_timeout():
	"""
	Adds 1 to all bllob ages
	"""

	for bllob_id in global.bllob_data:
		global.bllob_data[bllob_id]["age"] += 1

		global.bllob_dict[bllob_id].set_age(global.bllob_data[bllob_id]["age"])

func _on_Appetite_timeout(bllob_id):
	"""
	Decreases a bllobs hunger
	"""
	
	global.bllob_data[bllob_id]["hunger"] -= 1

func _on_Satisfaction_timeout(bllob_id):
	"""
	Decrease a bllobs happiness
	"""
	
	global.bllob_data[bllob_id]["happiness"] -= 1


func instance_bllob(bllob_id):
	"""
	Instances a new bllob with a given id or geneorates a new one
	"""
	var bllob = global.bllob_scene.instance()
		
	# Addes the bllobs and set the varaibles
	add_child(bllob)

	global.bllob_dict[bllob_id] = bllob

	global.bllob_dict[bllob_id].id = bllob_id
	global.bllob_dict[bllob_id].position.x = global.bllob_data[bllob_id]["position"][0]
	global.bllob_dict[bllob_id].position.y = global.bllob_data[bllob_id]["position"][1]
	
	global.bllob_dict[bllob_id].set_age(global.bllob_data[bllob_id]["age"])
	global.bllob_dict[bllob_id].set_colour(global.bllob_data[bllob_id]["colour"])
	
	global.bllob_dict[bllob_id].get_node("Appetite").wait_time = appetite_count*global.bllob_data[bllob_id]["appetite"]
	global.bllob_dict[bllob_id].get_node("Appetite").connect("timeout", self, "_on_Appetite_timeout", [bllob_id])
	
	global.bllob_dict[bllob_id].get_node("Satisfaction").wait_time = satisfaction_count*global.bllob_data[bllob_id]["satisfaction"]
	global.bllob_dict[bllob_id].get_node("Satisfaction").connect("timeout", self, "_on_Satisfaction_timeout", [bllob_id])


# =============
# GUI Methods
# =============

func update_coin_count(delta_coins):
	"""
	Updates the coin counter and GUI label
	"""
	global.coins += delta_coins
	
	$GUI/Node/Coins.text = "Coins: %s" % global.coins


func bllob_selected(bllob_id):
	"""
	Brings up the bllob gui panel displaying it's data
	"""
	# Used to update the panel live in _process
	selected_bllob_id = bllob_id
	$GUI.show_bllob_panel(selected_bllob_id, global.bllob_data[selected_bllob_id])

func _on_Egg_purchesed():
	"""
	Called when an egg is broght from the shop
	"""
	
	var egg_cost = 10
	
	if global.coins < egg_cost:
		return
	
	if len(global.bllob_data) >= 5:
		# 5 blobs max
		return
	
	# TODO:
	# The egg should really go to the hatchery but this is an example only
	
	update_coin_count(-10)
	
	var bllob = global.generate_bllob()
	var bllob_id = bllob.keys()[0]
	global.bllob_data[bllob_id] = bllob[bllob_id]
	
	instance_bllob(bllob_id)


func _on_Dodger_pressed():
	"""
	Called to start the dodger game
	"""
	global.make_save()
	
	get_tree().change_scene("res://scenes/bllob/dodger_game.tscn")
