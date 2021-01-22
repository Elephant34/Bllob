extends Node2D


# Contains all saved game data
var game_data

# Game specific variables
var coins
var raw_time

# Stores all data about bllobs
var bllob_data
var bllob_scene = preload("res://scenes/bllob/bllob.tscn")


# ===========================
# Overwridden game functions
# ===========================

func _ready():
	# Link to buttons to their event
	$GUI/Node/Games.connect("pressed", self, "_on_GamesBtn_pressed")
	$GUI/Node/Shop.connect("pressed", self, "_on_ShopBtn_pressed")
	$GUI/Node/Breeding.connect("pressed", self, "_on_BreedingBtn_pressed")
	$GUI/Node/Hatchery.connect("pressed", self, "_on_HatcheryBtn_pressed")
	
	
	# Load the game state
	game_data = load_save()
	
	coins = game_data["coins"]
	raw_time = game_data["raw_time"]
	bllob_data = game_data["bllob_data"]
	
	for bllob_id in bllob_data:
		# Instances all the bllobs
		var bllob = bllob_scene.instance()
		
		add_child(bllob)
		
		# Sets the bllob position
		bllob.position.x = bllob_data[bllob_id]["position"][0]
		bllob.position.y = bllob_data[bllob_id]["position"][1]
		
		# Sets the bllobs internal variables
		bllob.id = bllob_id
		bllob.age = bllob_data[bllob_id]["age"]
	
	update_coin_count()

func _process(dt):
	# Adds on to the raw game time
	raw_time += dt
	
	# Displays the game time
	# TODO format the time into a human friendly counter
	$GUI/Node/Time.text = "Time: %.2f" % raw_time


func _notification(what):
	# Runs when the game is quit
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		make_save()
		get_tree().quit() # default behavior


# =====================
# GUI button functions
# ======================

func _on_GamesBtn_pressed():
	$GUI.panel_button_pressed("games")

func _on_ShopBtn_pressed():
	$GUI.panel_button_pressed("shop")

func _on_BreedingBtn_pressed():
	$GUI.panel_button_pressed("breeding")

func _on_HatcheryBtn_pressed():
	$GUI.panel_button_pressed("hatchery")


func update_coin_count():
	# Updates the label showing coins
	$GUI/Node/Coins.text = "Coins: %s" % coins


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
	
	bllob_data = {
		"0": {
			"age": 0,
			"position": [148, 424]
		}
	}

func bllob_selected(bllob_id):
	print("Bllob selected %s" % bllob_id)
