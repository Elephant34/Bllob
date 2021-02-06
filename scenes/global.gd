extends Node


# Game scenes preloading
var home_prescene = preload("res://scenes/bllob/home.tscn")

# Save data variables
var game_data = {}
var name_list = []

# Game specific variables
var coins
var raw_time

# Bllob variables
var bllob_data = {}
var loaded_bllobs = {}
var bllob_prescene = preload("res://scenes/bllob/bllob.tscn")

# Default timer seconds
var appetite_count = 5
var satisfaction_count = 5
var aging_count = 20

var autosave_count = 30

var timer_paused = false


# ============================
# Overwritten Game Functions
# ============================#

func _ready():
	"""
	Called when scene fully loaded
	"""
	# Sets the random seed
	randomize()
	
	# Loads list of names
	name_list = load_names()
	name_list.shuffle()
	
	# Load the game state
	game_data = load_save()
	$AutoSave.wait_time = autosave_count
	$AutoSave.start()
	
	coins = game_data["coins"]
	raw_time = game_data["raw_time"]
	bllob_data = game_data["bllob_data"]
	
	
	var home_scene = home_prescene.instance()
	add_child(home_scene)


func _notification(what):
	# Runs when the game is quit
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		make_save()
		get_tree().quit() # default behavior


func _process(dt):
	"""
	Runs many times a second
	"""
	# Adds on to the raw game time
	if not timer_paused:
		raw_time += dt


# ================
# Misc Functions
# ================

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
	"""
	Sets all the variables for the first time
	"""
	coins = 0
	raw_time = 0.0
	
	bllob_data = generate_clean_bllob()


# =================
# Bllob Functions
# =================

func generate_clean_bllob():
	"""
	Generates a new bllob with no parents
	"""

	var new_bllob_data = {
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

	return new_bllob_data


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
	
	return temp_name


func new_bllob_position():
	"""
	Generates a new bllob positon which doesn't collide with any other bllob
	
	TODO: Make this better :)
	"""
	
	# 100 x 64 is size of sprite so this is taken into account for position
	var x_pos = rand_range(60, get_viewport().size.x - (50 + 60))
	var y_pos = rand_range(400, get_viewport().size.y - (32 + 40))
	
	return [x_pos, y_pos]
