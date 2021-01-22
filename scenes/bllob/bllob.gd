extends AnimatedSprite


var id
var age

var mouse_entered=false

# Temporary function to set variables until I link it to main
#func _ready():
#	id = 0
#	age = 0


func _on_baby_mouse_entered():
	mouse_entered=true


func _on_baby_mouse_exited():
	mouse_entered=false

func _input(event):
	# Checks if the mouse is in the bllob and if the input was a mouse press
	if event is InputEventMouseButton and mouse_entered:
		# Checks the mouse press was a left click
		if event.button_index == BUTTON_LEFT and event.pressed:
			# Checks if the scene is being run directly
			if get_parent() is Viewport:
				print("In debug %s- cannot call GUI" % id)
				return
			
			get_parent().bllob_selected(id)
