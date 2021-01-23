extends AnimatedSprite


var mouse_entered = false

# ==================
# Bllob Attributes
# ==================
var id

var age
var life_stage


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


func set_age(new_age):
	"""
	Sets the bllobs age and updates animation if needed
	"""
	age = new_age

	# Sets the correct animation and therefore the correct texture for sprite
	if age >= 0:
		life_stage = "adult"
	
	animation=life_stage
	playing=true
