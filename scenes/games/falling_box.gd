extends Sprite


var speed = 150

func _ready():
	"""
	Sets up the falling box
	"""
	
	position = Vector2(
		randi() % int(get_viewport_rect().size.x),
		-50
	)

func _process(dt):
	"""
	Updates position
	"""
	
	position.y += speed * dt
	
	if position.y > get_viewport_rect().size.y+100:
		queue_free()
