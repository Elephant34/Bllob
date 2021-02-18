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
				
				# For now give food to lowest hunger
				var current_bllob = ["bllob id", 1000]
				for bllob_id in global.bllob_data:
					if global.bllob_data[bllob_id].hunger < current_bllob[1]:
						current_bllob = [bllob_id,global.bllob_data[bllob_id].hunger]
				
				global.bllob_data[current_bllob[0]].hunger += 20

				# Ensures bllobs cannot exceed max hunger
				if global.bllob_data[current_bllob[0]].hunger > 100:
					global.bllob_data[current_bllob[0]].hunger = 100
				
				
