extends AnimatedSprite


var mouse_entered = false

# ==================
# Bllob Attributes
# ==================
var id

var age
var life_stage

var health
var hunger
var happiness

var strength
var agility
var staminer


func _on_baby_mouse_entered():
	mouse_entered = true

func _on_baby_mouse_exited():
	mouse_entered = false

func _input(event):
	# Checks if the mouse is in the bllob and if the input was a mouse press
	if event is InputEventMouseButton and mouse_entered:
		# Checks the mouse press was a left click
		if event.button_index == BUTTON_LEFT and event.pressed:
			# Checks if the scene is being run directly
			if get_parent() is Viewport:
				print("In debug %s- cannot call GUI" % id)
				return
			
			# Call the parent function to display bllob gui
			get_parent().bllob_selected(id)


func add_data(bllob_data):
	"""
	Sets the bllobs variables from a dictionary
	"""
	
	# Sets the bllob position
	position.x = bllob_data[id]["position"][0]
	position.y = bllob_data[id]["position"][1]
	
	# Sets the bllobs internal variables
	age = bllob_data[id]["age"]
	health = bllob_data[id]["health"]
	hunger = bllob_data[id]["hunger"]
	happiness = bllob_data[id]["happiness"]
	strength = bllob_data[id]["strength"]
	agility = bllob_data[id]["agility"]
	staminer = bllob_data[id]["staminer"]
	
	# Sets the correct animation and therefore the correct texture for sprite
	if age >= 0:
		life_stage = "adult"
	
	animation=life_stage
	playing=true
