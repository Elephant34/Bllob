extends Sprite


var speed = 150


func _ready():
	"""
	Sets up the falling box
	"""
	
	$Area2D.add_to_group("coins")
	
	position = Vector2(
		randi() % int(get_viewport_rect().size.x),
		-100
	)

func _process(dt):
	"""
	Updates position
	"""
	
	position.y += speed * dt
	
	# Makes the box dissapear when no longer visible
	if position.y > get_viewport_rect().size.y+100:
		queue_free()
