extends Node2D


# Contains all saved game data
var game_data

var coins
var time

func _ready():
	# Link to buttons to their event
	$GUI/Node/Games.connect("pressed", self, "_on_GamesBtn_pressed")
	$GUI/Node/Shop.connect("pressed", self, "_on_ShopBtn_pressed")
	$GUI/Node/Breeding.connect("pressed", self, "_on_BreedingBtn_pressed")
	$GUI/Node/Hatchery.connect("pressed", self, "_on_HatcheryBtn_pressed")
	
	game_data = load_save()
	coins = game_data["coins"]
	time = game_data["time"]

func _on_GamesBtn_pressed():
	$GUI.panel_button_pressed("games")

func _on_ShopBtn_pressed():
	$GUI.panel_button_pressed("shop")

func _on_BreedingBtn_pressed():
	$GUI.panel_button_pressed("breeding")

func _on_HatcheryBtn_pressed():
	$GUI.panel_button_pressed("hatchery")

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
		"time": time
	}
	
	var game_save = File.new()
	
	game_save.open("user://bllob.save", File.WRITE)
	
	game_save.store_var(to_json(game_data))
	
	game_save.close()

func new_game():
	coins = 0
	time = 0.0
