extends Control


var global


var egg_price = 50
var food_price = 10


func _ready():
	global = get_tree().get_current_scene()


func _on_Item_pressed(item):
	"""
	Determins the item attempting to be purchased
	"""
	
	match item:
		"egg":
			if global.coins >= egg_price:
				global.coins -= egg_price
				
				var egg_data = global.generate_clean_bllob()
				global.add_bllob(egg_data)
		"food":
			if global.coins >= food_price:
				global.coins -= food_price
				print("food")
