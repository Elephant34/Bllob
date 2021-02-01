extends Node2D


# Contains all saved game data
var game_data = {}
var name_list = []

# Game specific variables
var coins
var raw_time

# Stores all data about bllobs
var bllob_data = {}
var bllob_dict = {}
var bllob_scene = preload("res://scenes/bllob/bllob.tscn")

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
	# Ensures random variables are random
	randomize()
	
	# Connects all signals to functions
	connect_signals()
	
	# Loads list of names
	name_list = load_names()
	name_list.shuffle()
	
	# Load the game state
	game_data = load_save()
	
	coins = game_data["coins"]
	raw_time = game_data["raw_time"]
	bllob_data = game_data["bllob_data"]
	
	$AutoSave.wait_time = autosave_count
	$Aging.wait_time = aging_count
	
	# Adds all saved bllobs
	for bllob_id in bllob_data:
		instance_bllob(bllob_id)
	
	update_coin_count(0)

func _process(dt):
	# Adds on to the raw game time
	raw_time += dt
	
	if $GUI/Node/BllobPanel.visible:
		$GUI.show_bllob_panel(selected_bllob_id, bllob_data[selected_bllob_id])
	
	# Displays the game time
	# TODO format the time into a human friendly counter
	$GUI/Node/Time.text = "Time: %.2f" % raw_time


func _notification(what):
	# Runs when the game is quit
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		make_save()
		get_tree().quit() # default behavior


# =======
# Other
# =======


func connect_signals():
	"""
	Connects any signals from button presses to functions
	"""
	
	$GUI/Node/MenuPanel/ShopPanel/Egg.connect("pressed", self, "_on_egg_purchesed")


func load_names():
	"""
	Loads list of common names from text file
	"""
	
	var names = []
	
	var f = File.new()
	f.open("assets/name_list.txt", File.READ)
	
	# Iterates through all lines and appends the name
	while not f.eof_reached():
		names.append(f.get_line())
	f.close()
	
	return names


# ================
# Save Functions
# ================

func _on_AutoSave_timeout():
	# Autosaves the game based off timer
	make_save()

func load_save():
	var game_save = File.new()
	if not game_save.file_exists("user://bllob.save"):
		# Save does not exist new game must be created
		new_game()
		make_save()
	
	game_save.open("user://bllob.save", File.READ)
	
	var data = parse_json(game_save.get_var())
	
	game_save.close()
	
	return data

func make_save():
	game_data = {
		"coins": coins,
		"raw_time": raw_time,
		"bllob_data": bllob_data
	}
	
	var game_save = File.new()
	
	game_save.open("user://bllob.save", File.WRITE)
	
	game_save.store_var(to_json(game_data))
	
	game_save.close()


func new_game():
	coins = 0
	raw_time = 0.0
	
	bllob_data = generate_bllob()


# ===============
# Bllob methods
# ===============

func _on_Aging_timeout():
	"""
	Adds 1 to all bllob ages
	"""

	for bllob_id in bllob_data:
		bllob_data[bllob_id]["age"] += 1

		bllob_dict[bllob_id].set_age(bllob_data[bllob_id]["age"])

func _on_Appetite_timeout(bllob_id):
	"""
	Decreases a bllobs hunger
	"""
	
	bllob_data[bllob_id]["hunger"] -= 1

func _on_Satisfaction_timeout(bllob_id):
	"""
	Decrease a bllobs happiness
	"""
	
	bllob_data[bllob_id]["happiness"] -= 1


func instance_bllob(bllob_id):
	"""
	Instances a new bllob with a given id or geneorates a new one
	"""
	var bllob = bllob_scene.instance()
		
	# Addes the bllobs and set the varaibles
	add_child(bllob)

	bllob_dict[bllob_id] = bllob

	bllob_dict[bllob_id].id = bllob_id
	bllob_dict[bllob_id].position.x = bllob_data[bllob_id]["position"][0]
	bllob_dict[bllob_id].position.y = bllob_data[bllob_id]["position"][1]
	
	bllob_dict[bllob_id].set_age(bllob_data[bllob_id]["age"])
	bllob_dict[bllob_id].set_colour(bllob_data[bllob_id]["colour"])
	
	bllob_dict[bllob_id].get_node("Appetite").wait_time = appetite_count*bllob_data[bllob_id]["appetite"]
	bllob_dict[bllob_id].get_node("Appetite").connect("timeout", self, "_on_Appetite_timeout", [bllob_id])
	
	bllob_dict[bllob_id].get_node("Satisfaction").wait_time = satisfaction_count*bllob_data[bllob_id]["satisfaction"]
	bllob_dict[bllob_id].get_node("Satisfaction").connect("timeout", self, "_on_Satisfaction_timeout", [bllob_id])


func generate_bllob():
	"""
	Generates a new bllob with random attributes
	"""

	var temp_data = {
		"%s" % new_bllob_name(): {
			"colour": [randf(), randf(), randf()],
			"position": new_bllob_position(),
			"age": 0,
			"max_age": 100,
			"satisfaction": 1,
			"appetite": 1,
			"health": 100,
			"hunger": 100,
			"happiness": 100,
			"strength": 10,
			"agility":10,
			"staminer":10,
		}
	}

	return temp_data


func new_bllob_name():
	"""
	Generates a new bllob name and checks for duplication
	"""
	
	var temp_name = null
	
	for _name in name_list:
		if not(_name in bllob_data.keys()):
			temp_name = _name
			break
	
	if not temp_name:
		var index = 0
		var count = 1
		while true:
			temp_name = name_list[index] + "#%s" % count
			
			if temp_name in bllob_data.keys():
				index += 1
				if index == name_list.size():
					index = 0
					count += 1
			else:
				break
	
	print(temp_name)
	
	return temp_name


func new_bllob_position():
	"""
	Generates a new bllob positon which doesn't collide with any other bllob
	"""
	
	# 100 x 64 is size of sprite so this is taken into account for position
	print(get_viewport().size.y - (32 + 40))
	var x_pos = rand_range(60, get_viewport().size.x - (50 + 60))
	var y_pos = rand_range(400, get_viewport().size.y - (32 + 40))
	
	# TODO:
	# Check collision
	
	return [x_pos, y_pos]


# =============
# GUI Methods
# =============

func update_coin_count(delta_coins):
	"""
	Updates the coin counter and GUI label
	"""
	coins += delta_coins
	
	$GUI/Node/Coins.text = "Coins: %s" % coins


func bllob_selected(bllob_id):
	"""
	Brings up the bllob gui panel displaying it's data
	"""
	# Used to update the panel live in _process
	selected_bllob_id = bllob_id
	$GUI.show_bllob_panel(selected_bllob_id, bllob_data[selected_bllob_id])

func _on_egg_purchesed():
	"""
	Called when an egg is broght from the shop
	"""
	
	# TODO:
	# Coin stuff
	# The egg should really go to the hatchery but this is an exaple only
	var bllob = generate_bllob()
	var bllob_id = bllob.keys()[0]
	bllob_data[bllob_id] = bllob[bllob_id]
	
	instance_bllob(bllob_id)
