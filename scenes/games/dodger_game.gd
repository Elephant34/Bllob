extends Node2D


var global


var box_prescene = preload("res://scenes/games/falling_box.tscn")
var coin_prescene = preload("res://scenes/games/coin.tscn")

var game_time = 0

var inital_coins


func _ready():
	global = get_tree().get_current_scene()
	
	inital_coins = global.coins
	
	var bllob = global.bllob_prescene.instance()
	
	# Gets a random bllob from save
	var bllob_id = global.bllob_data.keys()[randi()%global.bllob_data.size()]
	bllob.setup(bllob_id, "dodger")
	add_child(bllob)


func _process(dt):
	game_time += dt


func _on_Home_pressed():
	game_over()


func _on_BoxTimer_timeout():
	"""
	Has a chance to spawn a new box
	The probability will tend towards 100% as time passes
	"""
	
	# Function which dectates the odds a box will spawn
	# It is an s shape starting at 0.9 and tending to 0
	var probability = 0.8/(1+pow((((1/160.0)*game_time)/(1-((1/120.0)*game_time))),2.1))
	# NOTE- all divisions must have one number which is a float or they equal 0
	
	if randf() > probability:
		var box = box_prescene.instance()
		
		add_child(box)


func _on_CoinTimer_timeout():
	"""
	Spawns a new coin
	"""
	
	# Will be based on a time function
	var propability = 0.7
	
	if randf() > propability:
		var coin = coin_prescene.instance()
		
		add_child(coin)


func game_over():
	"""
	Calculates score and goes back to home screen
	"""
	
	var delta_coins = global.coins - inital_coins
	
	# Score will be used to work out xp
	var score = (delta_coins+1) * (game_time/8)
	print(score)
	
	global.load_home()
